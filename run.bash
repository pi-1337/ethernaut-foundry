for i in {1..10}; do
  forge script script/CoinFlipSolution.s.sol \
    --broadcast -vvv
  sleep 14 # ~block time
done
