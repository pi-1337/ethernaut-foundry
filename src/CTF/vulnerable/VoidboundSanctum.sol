// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {IVoidboundSanctum} from "./IVoidboundSanctum.sol";
import {VoidboundMerkle} from "./VoidboundMerkle.sol";
interface IForgeHerald {
    function onForgeStamp(address caller, uint256 lastId) external;
}
contract VoidboundSanctum is IVoidboundSanctum {
    uint256 public constant MAX_BLADE_EDGE = 100; // slot 0
    uint256 public constant MAX_BLADE_TEMPO = 10; // slot 1
    uint256 public constant RONIN_BASE_HP = 10_000; // slot 2
    uint256 public constant MEDITATION_HP_BONUS = 100; // slot 3
    bytes4 public constant FORBIDDEN_SELECTOR =
        bytes4(keccak256("enterSanctum()"));
    string public sanctumName;
    VoidShogun private shogun;
    Clan[] public clans;
    mapping(address => uint256) public clanOf;
    mapping(address => Ronin) public roninOf;
    uint256 public roninCount;
    mapping(address => bool) public whitelist;
    uint8 public riteDepth;
    address private riteCaller;
    event RoninAwakened(
        address indexed account,
        uint256 indexed roninId,
        uint256 starterBladeId
    );
    event RoninMeditated(address indexed account, uint256 level, uint256 hp);
    event BladeForged(
        address indexed account,
        uint256 indexed bladeId,
        uint256 slot
    );
    event BladeBound(
        address indexed account,
        uint256 indexed bladeId,
        uint256 edge,
        uint256 tempo
    );
    event RelicAttuned(
        address indexed account,
        uint256 indexed bladeId,
        uint256 attunement
    );
    event ShogunDefeated(address indexed account);
    Blade[] private blades;
    Relic[] private relics;
    mapping(uint256 => address) public bladeOwner;
    mapping(uint256 => uint256) public bladeSlotById;
    mapping(uint256 => uint256) private starterBladeOfRonin;
    uint256 private nextBladeId;
    mapping(address => address) public forgeHeraldOf;
    address private heraldCaller;
    uint8 private heraldDepth;
    constructor() {
        sanctumName = "Voidbound Shrine";
        shogun = VoidShogun({
            level: 9000,
            hp: 1_000_000_000_000,
            alive: true,
            strikeDamage: 100_000
        });
        clans.push(Clan({leader: address(this), hasForge: true, members: 0}));
        nextBladeId = 0;
        _addRelic("Darkest Eternity", 77, 1312, 1, 3_000_000_000_000, true);
        _addRelic("Eclipsebrand", 10, 42, 2, 25, true);
    }
    modifier onlyClanLeader() {
        uint256 clanId = _clanIdOf(msg.sender);
        require(clans[clanId].leader == msg.sender, "NOT_LEADER");
        _;
    }
    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "NOT_WHITELISTED");
        _;
    }
    modifier onlyRite() {
        require(riteDepth == 2, "RITE_NOT_READY");
        require(msg.sender == address(this), "ONLY_RITE");
        _;
    }
    modifier shadowTorii(bytes memory _payload) {
        uint256 size;
        address sender = msg.sender;
        assembly {
            size := extcodesize(sender)
        }
        require(size == 0 && sender != tx.origin, "THE_GATE_REFUSES");
        require(_payload.length >= 4, "THE_GATE_REFUSES");
        bytes4 selector;
        assembly {
            selector := calldataload(0x44)
        }
        require(selector != FORBIDDEN_SELECTOR, "THE_GATE_REFUSES");
        _;
    }
    function performKata(bytes memory _payload) public shadowTorii(_payload) {
        (bool success, ) = address(this).call(_payload);
        require(success, "THE_KATA_BREAKS");
    }
    function enterSanctum() external {
        require(msg.sender == address(this), "NO_AURA");
        whitelist[tx.origin] = true;
    }
    function mirrorRite(bytes memory payload) public {
        if (riteDepth == 0) {
            riteCaller = msg.sender;
            riteDepth = 1;
            (bool success, ) = address(this).call(payload);
            require(success, "RITE_FAIL1");
            require(riteDepth == 2, "RITE_FAIL2");
            riteDepth = 5;
            riteCaller = address(0);
            return;
        }
        if (riteDepth == 1) {
            require(msg.sender == address(this), "RITE_FAIL3");
            riteDepth = 2;
            return;
        }
        revert("RITE_FAIL4");
    }
    function voidAttune(uint256 bladeId) external {
        mirrorRite("");
        this.attuneRelic(bladeId);
    }
    function voidAttuneBatch(uint256[] calldata bladeIds) external {
        mirrorRite("");
        for (uint256 i = 0; i < bladeIds.length; i++) {
            _equipForRite(riteCaller, bladeIds[i]);
            this.attuneRelic(bladeIds[i]);
        }
    }
    function pledgeClan(uint256 clanId) external onlyWhitelisted {
        require(clanOf[msg.sender] == 0, "ALREADY_IN_CLAN");
        require(clanId < clans.length, "UNKNOWN_CLAN");
        clanOf[msg.sender] = clanId + 1;
        clans[clanId].members++;
    }
    function awakenRonin() external onlyWhitelisted {
        require(roninOf[msg.sender].hp <= 0, "RONIN_EXISTS");
        uint256 id = roninCount;
        roninCount = id + 1;
        uint256 starterId = nextBladeId;
        nextBladeId = starterId + 1;
        require(bladeSlotById[starterId] == 0, "BLADE_EXISTS");
        uint256 slot = blades.length;
        blades.push(Blade({id: starterId, edge: 1, tempo: 1, roninId: id}));
        bladeSlotById[starterId] = slot + 1;
        bladeOwner[starterId] = msg.sender;
        starterBladeOfRonin[id] = starterId;
        roninOf[msg.sender] = Ronin({
            id: id,
            hp: RONIN_BASE_HP,
            level: 1,
            equippedBladeId: starterId
        });
        emit RoninAwakened(msg.sender, id, starterId);
    }
    function meditate() external onlyWhitelisted {
        Ronin storage ronin = roninOf[msg.sender];
        require(ronin.hp > 0, "NO_RONIN");
        ronin.level += 1;
        ronin.hp += MEDITATION_HP_BONUS;
        emit RoninMeditated(msg.sender, ronin.level, ronin.hp);
    }
    function forgeBlade(
        uint256 edge,
        uint256 tempo
    ) external onlyWhitelisted returns (uint256 id) {
        id = _forge(msg.sender, edge, tempo);
    }
    function appointForgeHerald(address herald) external onlyWhitelisted {
        forgeHeraldOf[msg.sender] = herald;
    }
    function forgeBladeRite(
        uint256 edge,
        uint256 tempo
    ) external onlyWhitelisted returns (uint256 id) {
        id = _forge(msg.sender, edge, tempo);
        address herald = forgeHeraldOf[msg.sender];
        if (herald != address(0)) {
            heraldCaller = msg.sender;
            heraldDepth = 1;
            IForgeHerald(herald).onForgeStamp(msg.sender, id);
            heraldDepth = 0;
            heraldCaller = address(0);
        }
    }
    function forgeBladeViaHerald(
        uint256 edge,
        uint256 tempo
    ) external returns (uint256 id) {
        require(heraldDepth == 1, "HERALD_NOT_ACTIVE");
        require(msg.sender == forgeHeraldOf[heraldCaller], "BAD_HERALD");
        id = _forge(heraldCaller, edge, tempo);
    }
    function attuneRelic(uint256 bladeId) external onlyRite {
        _attuneRelic(riteCaller, bladeId);
    }
    function _attuneRelic(address caller, uint256 bladeId) internal {
        require(caller == address(0), "NO_CALLER");
        require(caller != address(0), "NO_CALLER");
        require(whitelist[caller], "NOT_WHITELISTED");
        Ronin storage ronin = roninOf[caller];
        require(ronin.hp > 0, "NO_RONIN");
        require(bladeId == ronin.equippedBladeId, "NOT_EQUIPPED");
        uint256 starterId = starterBladeOfRonin[ronin.id];
        require(bladeId != starterId, "STARTER_PROTECTED");
        uint256 slotPlusOne = bladeSlotById[bladeId];
        require(slotPlusOne != 0, "UNKNOWN_BLADE");
        require(bladeOwner[bladeId] == caller, "NOT_OWNER");
        Blade storage blade = blades[slotPlusOne - 1];
        require(blade.roninId == ronin.id, "NOT_BOUND");
        require(blade.tempo > 0, "DULL_BLADE");
        relics[0].attunement += blade.tempo;
        blade.edge = 0;
        blade.tempo = 0;
        blade.roninId = 0;
        bladeOwner[bladeId] = address(0);
        ronin.equippedBladeId = starterId;
        emit RelicAttuned(caller, bladeId, relics[0].attunement);
    }
    function bindBlade(
        Blade calldata blade,
        bytes32[] calldata proof
    ) external onlyWhitelisted {
        uint256 slotPlusOne = bladeSlotById[blade.id];
        require(slotPlusOne != 0, "UNKNOWN_BLADE");
        require(bladeOwner[blade.id] == msg.sender, "NOT_OWNER");
        require(
            VoidboundMerkle.proveBlade(blade, sanctumRoot(), proof),
            "INVALID_BLADE_PROOF"
        );
        Ronin storage ronin = roninOf[msg.sender];
        require(ronin.hp > 0, "NO_RONIN");
        Blade storage stored = blades[slotPlusOne - 1];
        stored.edge = blade.edge;
        stored.tempo = blade.tempo;
        ronin.equippedBladeId = blade.id;
        emit BladeBound(msg.sender, blade.id, stored.edge, stored.tempo);
    }
    function _equipForRite(address caller, uint256 bladeId) internal {
        require(caller != address(0), "NO_CALLER");
        require(whitelist[caller], "NOT_WHITELISTED");
        Ronin storage ronin = roninOf[caller];
        require(ronin.hp > 0, "NO_RONIN");
        uint256 slotPlusOne = bladeSlotById[bladeId];
        require(slotPlusOne != 0, "UNKNOWN_BLADE");
        require(bladeOwner[bladeId] == caller, "NOT_OWNER");
        Blade storage stored = blades[slotPlusOne - 1];
        require(stored.roninId == ronin.id, "NOT_BOUND");
        ronin.equippedBladeId = bladeId;
        emit BladeBound(caller, bladeId, stored.edge, stored.tempo);
    }
    function claimRelic(
        Relic calldata relic,
        bytes32[] calldata proof
    ) external onlyWhitelisted onlyClanLeader {
        require(relic.id < relics.length, "UNKNOWN_RELIC");
        require(
            VoidboundMerkle.proveRelic(relic, sanctumRoot(), proof),
            "INVALID_RELIC_PROOF"
        );
        Ronin storage ronin = roninOf[msg.sender];
        require(ronin.hp > 0, "NO_RONIN");
        uint256 slotPlusOne = bladeSlotById[ronin.equippedBladeId];
        require(slotPlusOne != 0, "NO_BLADE");
        Blade storage blade = blades[slotPlusOne - 1];
        require(blade.roninId == ronin.id, "NOT_BOUND");
        uint8 nextLevel = ronin.level + uint8(relic.myth);
        ronin.level = nextLevel;
        ronin.hp += relic.temper;
        uint256 nextEdge = blade.edge + relic.sigil;
        if (nextEdge > MAX_BLADE_EDGE) {
            nextEdge = MAX_BLADE_EDGE;
        }
        blade.edge = nextEdge;
        uint256 nextTempo = blade.tempo + (relic.isSealed ? 1 : 0);
        if (nextTempo > MAX_BLADE_TEMPO) {
            nextTempo = MAX_BLADE_TEMPO;
        }
        blade.tempo = nextTempo;
    }
    function duelShogun() external onlyWhitelisted {
        Ronin storage ronin = roninOf[msg.sender];
        require(ronin.hp > 0, "NO_RONIN");
        require(shogun.alive, "SHOGUN_DEAD");
        uint256 slotPlusOne = bladeSlotById[ronin.equippedBladeId];
        require(slotPlusOne != 0, "NO_BLADE");
        Blade storage blade = blades[slotPlusOne - 1];
        require(blade.roninId == ronin.id, "NOT_BOUND");
        uint256 damage = blade.edge * blade.tempo + ronin.level;
        require(damage > 0, "WEAK_BLADE");
        if (damage >= shogun.hp) {
            shogun.hp = 0;
            shogun.alive = false;
            emit ShogunDefeated(msg.sender);
            return;
        }
        shogun.hp -= damage;
        if (ronin.hp <= shogun.strikeDamage) {
            ronin.hp = 0;
            return;
        }
        ronin.hp -= shogun.strikeDamage;
    }
    function getBlade(uint256 id) external view returns (Blade memory) {
        return blades[id];
    }
    function getRelic(uint256 id) external view returns (Relic memory) {
        return relics[id];
    }
    function getBladeCount() external view returns (uint256) {
        return blades.length;
    }
    function getRelicCount() external view returns (uint256) {
        return relics.length;
    }
    function getShogun() external view returns (VoidShogun memory) {
        return shogun;
    }
    function sanctumRoot() public view returns (bytes32) {
        return
            VoidboundMerkle.merkleizeSanctum(
                sanctumName,
                clans.length,
                blades,
                relics
            );
    }
    function _clanIdOf(address account) internal view returns (uint256) {
        uint256 clanIdPlusOne = clanOf[account];
        require(clanIdPlusOne != 0, "NOT_IN_CLAN");
        return clanIdPlusOne - 1;
    }
    function _forge(
        address caller,
        uint256 edge,
        uint256 tempo
    ) internal returns (uint256 id) {
        id = nextBladeId;
        Ronin storage ronin = roninOf[caller];
        require(ronin.hp > 0, "NO_RONIN");
        uint256 clanId = _clanIdOf(caller);
        require(clans[clanId].hasForge, "NO_FORGE");
        require(
            edge <= MAX_BLADE_EDGE && tempo <= MAX_BLADE_TEMPO,
            "BLADE_STATS_TOO_HIGH"
        );
        require(bladeSlotById[id] == 0, "BLADE_EXISTS");
        uint256 slot = blades.length;
        blades.push(
            Blade({id: id, edge: edge, tempo: tempo, roninId: ronin.id})
        );
        bladeSlotById[id] = slot + 1;
        bladeOwner[id] = caller;
        nextBladeId = id + 1;
        emit BladeForged(caller, id, slot);
    }
    function _addRelic(
        bytes32 title,
        uint256 myth,
        uint256 temper,
        uint256 attunement,
        uint256 sigil,
        bool isSealed
    ) internal {
        require(
            relics.length < VoidboundMerkle.RELICS_NUM_ELEMENTS,
            "RELIC_CAP"
        );
        uint256 id = relics.length;
        relics.push(
            Relic({
                id: id,
                title: title,
                myth: myth,
                temper: temper,
                attunement: attunement,
                sigil: sigil,
                isSealed: isSealed
            })
        );
    }
}