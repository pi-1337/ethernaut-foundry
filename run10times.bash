
for i in {1..11}
do
	forge script  script/CoinFlip.s.sol -vvvv --broadcast  --tc CoinFlipSolver
	sleep  20
    echo "Number: $i"
done

forge script script/CoinFlip.s.sol -vvvv --broadcast


