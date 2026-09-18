count=0
runs=0
trap 'echo "Runs: $runs, Total CRC Error: $count"; exit 0' INT
while true; do
    runs=$((runs + 1))
    out=$(./test_arm_lowlevel --goto --q 1.1 0.5 0.5 1 1 -0.2 1.3 --kp 60 2>&1)
    count=$((count + $(printf '%s\n' "$out" | grep -c "CRC Error")))
    echo "Runs: $runs, Total CRC Error: $count"
#    sleep 2
    runs=$((runs + 1))
    out=$(./test_arm_lowlevel --goto --q -1.1 1.5 1.5 0.5 0 0.2 -1.3 --kp 40 2>&1)
    count=$((count + $(printf '%s\n' "$out" | grep -c "CRC Error")))
    echo "Runs: $runs, Total CRC Error: $count"
#    sleep 2
done
