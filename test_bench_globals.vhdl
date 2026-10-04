library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package test_bench_globals is 

    constant TEST_BENCH_CLOCK_PERIOD : time := 2.5 ns; -- 400mhz
    constant TEST_BENCH_ITERATION : time := TEST_BENCH_CLOCK_PERIOD * 2;

end package;