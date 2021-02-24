#!/bin/ash

set -eu

curl -i -X POST "${INFLUX_ADDR}/query" --data-urlencode "q=CREATE DATABASE ${INFLUX_DB}"

while true
do
    device=`curl -s -G "${EXCAVATOR_ADDR}/api" --data-urlencode "command={\"method\":\"device.get\",\"id\":1,\"params\":[\"${GPU_ID}\"]}"`
    device_temp=`echo $device | jq ".device.gpu_temp"`
    device_load=`echo $device | jq ".device.gpu_load"`
    device_power=`echo $device | jq ".device.gpu_power_usage"`
    device_core_clock=`echo $device | jq ".device.gpu_clock_core"`
    device_memory_clock=`echo $device | jq ".device.gpu_clock_memory"`
    device_memory_free=`echo $device | jq ".device.gpu_memory_free"`
    device_memory_used=`echo $device | jq ".device.gpu_memory_used"`
    device_fan_percent=`echo $device | jq ".device.gpu_fan_speed"`
    device_fan_rpm=`echo $device | jq ".device.gpu_fan_speed_rpm"`
    device_errors=`echo $device | jq ".device.hw_errors"`
    device_errors_success=`echo $device | jq ".device.hw_errors_success"`
    device_kernel_time_avg=`echo $device | jq ".device.kernel_times.avg"`
    device_kernel_time_min=`echo $device | jq ".device.kernel_times.min"`
    device_kernel_time_max=`echo $device | jq ".device.kernel_times.max"`
    device_kernel_time_umed=`echo $device | jq ".device.kernel_times.umed"`
    curl -s -X POST "${INFLUX_ADDR}/write?db=${INFLUX_DB}&precision=s" --data-binary "device,type=${GPU_ID} temp=${device_temp},load=${device_load},power=${device_power},core_clock=${device_core_clock},memory_clock=${device_memory_clock},memory_free=${device_memory_free},memory_used=${device_memory_used},fan_percent=${device_fan_percent},fan_rpm=${device_fan_rpm},errors=${device_errors},errors_success=${device_errors_success},kernel_time_avg=${device_kernel_time_avg},kernel_time_min=${device_kernel_time_min},kernel_time_max=${device_kernel_time_max},kernel_time_umed=${device_kernel_time_umed}"

    worker=`curl -s -G "${EXCAVATOR_ADDR}/api" --data-urlencode 'command={"method":"worker.list","id":1,"params":[]}'`
    worker_hashrate=`echo $worker | jq ".workers[0].algorithms[0].speed"`
    curl -s -X POST "${INFLUX_ADDR}/write?db=${INFLUX_DB}&precision=s" --data-binary "worker hashrate=${worker_hashrate}"

    sleep ${INTERVAL}
done
