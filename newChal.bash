touch ./src/$1.sol
touch ./script/$1.s.sol
cp ./script/Token.s.sol ./script/$1.s.sol
export payload='s/Token/'
export payload+=$1
export payload+='/g'
sed -i -e $payload ./script/$1.s.sol
export payload='s/0x5b84Aee912D7B4247787230E9057f07feAc1143F/'
export payload+=$2
export payload+='/g'
sed -i -e $payload ./script/$1.s.sol
ls src | grep $1
ls script | grep $1

head -n 2 ./src/$1.sol > tmp1
tail -n +3 ./script/$1.s.sol > tmp2

cat tmp1 > ./script/$1.s.sol
cat tmp2 >> ./script/$1.s.sol

rm tmp1 tmp2