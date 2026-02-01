# SECP256K1
p = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F  # Prime modulus
a = 0  # Curve parameter a for secp256k1
b = 7  # Curve parameter b for secp256k1
G_x = 0x79BE667EF9DCBBAC55A62DAD8B8D8D1D7D20A1B395B6B5D4A82A2F5D4C9D75E9  # Base point G_x
G_y = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199E48B6B6CC0D2007  # Base point G_y

E = EllipticCurve(GF(p), [a, b])

G = E(0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798, 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8)
n = G.order()


def recoverPrivateKey(r, s1, s2, z1, z2):
    """
    
    r_i = k_i.G
    s_i = k_i(z_i + r_i.x)
    
    """

    k = ((z1 - z2)*pow(s1-s2, -1, n)) % n

    privatekey1 = ((s1*k-z1) * pow(r, -1, n)) % n
    privatekey2 = ((s2*k-z2) * pow(r, -1, n)) % n
    
    # everything is good
    assert privatekey1 == privatekey2
    
    return k, privatekey2


print("==== sanity check ====")

x = 31415926535897963238
k = 123456789
r = int((k*G).xy()[0])
z1 = 789456123545467878654
s1 = ((z1 + r*x)*pow(k, -1, n)) % n

z2 = 456789321654654798954
s2 = ((z2 + r*x)*pow(k, -1, n)) % n
    
print(recoverPrivateKey(r, s1, s2, z1, z2))




print("==== actual private key recovery ====")

r2 = 0xe5648161e95dbf2bfc687b72b745269fa906031e2108118050aba59524a23c40;
s2 = 0x70026fc30e4e02a15468de57155b080f405bd5b88af05412a9c3217e028537e3;
v2 = 27;

r1 = 0xe5648161e95dbf2bfc687b72b745269fa906031e2108118050aba59524a23c40;
s1 = 0x4c3ac03b268ae1d2aca1201e8a936adf578a8b95a49986d54de87cd0ccb68a79;
v1 = 27;

z1 = 0x6a0d6cd0c2ca5d901d94d52e8d9484e4452a3668ae20d63088909611a7dccc51
z2 = 0x937fa99fb61f6cd81c00ddda80cc218c11c9a731d54ce8859cb2309c77b79bf3

k, privatekey = recoverPrivateKey(r1, s1, s2, z1, z2)

print((k*G).xy()[0] == r1)


privatekey = hex(privatekey)
print(f"{k=}")
print(f"{privatekey=}")
