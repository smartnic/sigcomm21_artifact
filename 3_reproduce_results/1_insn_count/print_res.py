import os
import sys
import numpy as np
from prettytable import PrettyTable


def extract_data():
    folder_list = os.listdir('output/')
    folder_list.sort()
    o2_3_res = []
    k2 = []
    better = []
    overall = []

    for folder_name in folder_list:
        filename = 'output/' + folder_name + '/log.txt'
        f = open(filename)
        lines = f.readlines()
        better_candidate = 0
        for line in lines:
            if 'original' in line:
                o2_3_res.append(int(line.split(' ')[-1]))
            elif 'top 1' in line:
                k2.append(int(line.split(' ')[-1]))
            elif 'better' in line:
                cur_better = float(line.split(' ')[6])
                if better_candidate<cur_better:
                    better_candidate = cur_better
            elif 'compiling' in line:
                overall.append(int(float(line.split(' ')[-2])))

        better_candidate = round(better_candidate, 1)
        better.append(better_candidate)
        f.close()


    return folder_list, o2_3_res, k2, better, overall


def print_table(b_name, o23, k2, c_rate, better, overall):

    table_ins = PrettyTable()
    table_ins.title = 'Number of instructions'
    table_ins.add_column('Benchmark', b_name)
    table_ins.add_column('-O2/O3', o23)
    table_ins.add_column('K2', k2)
    table_ins.add_column('Compression (%)', c_rate)
    print(table_ins)

    table_time = PrettyTable()
    table_time.title = 'Elapsed time for finding programs (sec)'
    table_time.add_column('Benchmark', b_name)
    table_time.add_column('Time to the smallest program', better)
    table_time.add_column('Overall time', overall)
    print(table_time)

    return 0


def sys_main():
    b_name, o23, k2, better, overall = extract_data()
    o23 = np.array(o23)
    k2 = np.array(k2)
    compress_rate = (o23-k2)/o23 * 100
    compress_rate = np.round(compress_rate, decimals=2)

    print_table(b_name=b_name, o23=o23, k2=k2, c_rate=compress_rate, better=better, overall=overall)
    return 0


if __name__ == '__main__':
    sys_main()

