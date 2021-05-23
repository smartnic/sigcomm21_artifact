import os
import sys
import numpy as np
from prettytable import PrettyTable


def extract_data():
    filename = 'log.txt'
    benchmark = []
    sol_time = [[], [], [], [], []]
    f = open(filename)
    lines = f.readlines()
    counter = 0
    for line in lines:
        if 'benchmark' in line:
            benchmark.append(line.split(' ')[-1][:-1])
        elif 'validator solve eq' in line:
            sol_time[counter].append(int(float(line.split(' ')[-3])))
            counter = (counter + 1) % 5

    f.close()

    sol_time = np.array(sol_time)
    slow_down = []
    for i in range(0, 5):
        slow_down.append(np.round(sol_time[i]/sol_time[0]))
    #
    # print(benchmark)
    # print(sol_time)
    # print(slow_down)
    return benchmark, sol_time, slow_down


def print_table(benchmark, sol_time, slow_down):

    table_ins = PrettyTable()
    table_ins.title = 'Time consumption (us)'
    table_ins.add_column('Benchmark', benchmark)
    table_ins.add_column('I,II,III,IV', sol_time[0])
    table_ins.add_column('I,II,III', sol_time[1])
    table_ins.add_column('I,II', sol_time[2])
    table_ins.add_column('I', sol_time[3])
    table_ins.add_column('None', sol_time[4])
    print(table_ins)

    slow_down_string = [[], [], [], [], []]
    for i in range(0, len(slow_down)):
        for j in range(0,len(slow_down[i])):
            slow_down_string[i].append(str(int(slow_down[i][j])) + 'x')

    table_time = PrettyTable()
    table_time.title = 'Slow down (how many times slower than I,II,III,IV)'
    table_time.add_column('Benchmark', benchmark)
    table_time.add_column('I,II,III', slow_down_string[1])
    table_time.add_column('I,II', slow_down_string[2])
    table_time.add_column('I', slow_down_string[3])
    table_time.add_column('None', slow_down_string[4])
    print(table_time)

    return 0


def sys_main():
    benchmark, sol_time, slow_down = extract_data()

    print_table(benchmark=benchmark, sol_time=sol_time, slow_down=slow_down)
    return 0


if __name__ == '__main__':
    sys_main()

