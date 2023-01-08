import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

width = .40 # width of a bar

m1_t = pd.DataFrame({
 'LavaMD CUDA (128 Threads)' : [5.198964118958, 5.433316898346, 5.856960773468, 6.815187931061,
                  8.416694641113, 10.762124061584, 14.080483436584, 18.527675628662],
 'LavaMD CUDA (128 Threads) w/ 4-Streams' : [0.02440200001, 0.175071999431, 0.475046008825, 1.11676299572,
                             2.112684011459, 3.629460096359, 5.802453041077, 8.720497131348],
 'LavaMD CUDA (128 Threads) w/ 4-Streams + UVA': [0.020743999630, 0.155456006527, 0.443819999695, 0.985599994659,
                                               1.850350022316, 3.166248083115, 5.080418109894, 7.588675975800],
# 'normal' : [140,160,170,180,190,200,210,220,230,240],
 'Difference: No vs 4-Streams' : [5.174562118948, 5.258244898915, 5.381914764643, 5.698424935341,
                 6.304010629654, 7.132663965225, 8.278030395507, 9.807178497314],
    'Difference: 4-Streams vs 4-Streams + UVA': [0.00365800038, 0.019615992904, 0.03122600913, 0.131163001061,
                   0.262333989143, 0.463212013244, 0.722034931183001, 1.131821155548]})

#m1_t[['LavaMD CUDA (128 Threads)','LavaMD CUDA (128 Threads) w/ 4-Streams']].plot(kind='bar', width=width,
#                                                      ylabel='Execution time (s)',
#                                                      xlabel='Number of input values')
#m1_t[['LavaMD CUDA (128 Threads) w/ 4-Streams', 'LavaMD CUDA (128 Threads) w/ 4-Streams + UVA']].plot(kind='bar', width=width,
#                                                      ylabel='Execution time (s)',
#                                                      xlabel='Number of input values')
m1_t[['LavaMD CUDA (128 Threads)','LavaMD CUDA (128 Threads) w/ 4-Streams', 'LavaMD CUDA (128 Threads) w/ 4-Streams + UVA']].plot(kind='bar', width=width,
                                                      ylabel='Execution time (s)',
                                                      xlabel='Number of input values')
m1_t['Difference: No vs 4-Streams'].plot(secondary_y=True, mark_right =True, linestyle='dashed')
m1_t['Difference: 4-Streams vs 4-Streams + UVA'].plot(secondary_y=True, mark_right =True, linestyle='dashed')
ax = plt.gca()
# plt.xlim([-width, len(m1_t['LavaMD CUDA w/ Streams'])-width])
ax.set_xticklabels(('./lavaMD -boxes1d 20', './lavaMD -boxes1d 40', './lavaMD -boxes1d 60', './lavaMD -boxes1d 80',
                    './lavaMD -boxes1d 100', './lavaMD -boxes1d 120', './lavaMD -boxes1d 140', './lavaMD -boxes1d 160'))
ax.set_xlabel('Number of input values')
ax.set_ylabel('Time Difference (s)')
#ax.legend(labels=['Difference', 'LavaMD CUDA','LavaMD CUDA w/ 4-Streams'])
#ax.legend(labels=['Difference: No vs 4-Streams'], loc=1)
#ax.legend(labels=['Difference: 4-Streams vs 4-Streams + UVA'], loc=1)
ax.legend(labels=['Difference: No vs 4-Streams','Difference: 4-Streams vs 4-Streams and UVA'], loc=1)
# plt.xlabel('Number of input values')
# plt.ylabel('Execution time (s)')
# plt.title('Time at different number of boxes in one dimension')
plt.show()