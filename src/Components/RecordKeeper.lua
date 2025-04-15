-- Roll data Keys.
KEY_D4 = "d4"
KEY_D6 = "whited6"
KEY_EFFECT = "redd6"
KEY_D8 = "d8"
KEY_MOVEMENT = "movement"

-- Lookup table for nice printouts.
SANITIZED_ROLL_TYPES = {
  [KEY_D4] = "D4",
  [KEY_D6] = "Attack",
  [KEY_EFFECT] = "Effect",
  [KEY_D8] = "Crit",
  [KEY_MOVEMENT] = "Movement"
}

-- Table consisting of average rolls and std deviation for each die.
PERCENTILE_HELPER_TABLE = {
  [KEY_D4] = { avg = 2.5, std_dev = 1.118 },
  [KEY_D6] = { avg = 3.5, std_dev = 1.708 },
  [KEY_EFFECT] = { avg = 3.5, std_dev = 1.708 },
  [KEY_D8] = { avg = 4.0, std_dev = 1.732 },
  [KEY_MOVEMENT] = { avg = 3.5, std_dev = 1.708 },
}

-- Z scores table.
Z_SCORES = {
  [-3.0] = 0.0013,
  [-2.99] = 0.0014,
  [-2.98] = 0.0014,
  [-2.97] = 0.0015,
  [-2.96] = 0.0015,
  [-2.95] = 0.0016,
  [-2.94] = 0.0016,
  [-2.93] = 0.0017,
  [-2.92] = 0.0018,
  [-2.91] = 0.0018,
  [-2.9] = 0.0019,
  [-2.89] = 0.0019,
  [-2.88] = 0.002,
  [-2.87] = 0.0021,
  [-2.86] = 0.0021,
  [-2.85] = 0.0022,
  [-2.84] = 0.0023,
  [-2.83] = 0.0023,
  [-2.82] = 0.0024,
  [-2.81] = 0.0025,
  [-2.8] = 0.0026,
  [-2.79] = 0.0026,
  [-2.78] = 0.0027,
  [-2.77] = 0.0028,
  [-2.76] = 0.0029,
  [-2.75] = 0.003,
  [-2.74] = 0.0031,
  [-2.73] = 0.0032,
  [-2.72] = 0.0033,
  [-2.71] = 0.0034,
  [-2.7] = 0.0035,
  [-2.69] = 0.0036,
  [-2.68] = 0.0037,
  [-2.67] = 0.0038,
  [-2.66] = 0.0039,
  [-2.65] = 0.004,
  [-2.64] = 0.0041,
  [-2.63] = 0.0043,
  [-2.62] = 0.0044,
  [-2.61] = 0.0045,
  [-2.6] = 0.0047,
  [-2.59] = 0.0048,
  [-2.58] = 0.0049,
  [-2.57] = 0.0051,
  [-2.56] = 0.0052,
  [-2.55] = 0.0054,
  [-2.54] = 0.0055,
  [-2.53] = 0.0057,
  [-2.52] = 0.0059,
  [-2.51] = 0.006,
  [-2.5] = 0.0062,
  [-2.49] = 0.0064,
  [-2.48] = 0.0066,
  [-2.47] = 0.0068,
  [-2.46] = 0.0069,
  [-2.45] = 0.0071,
  [-2.44] = 0.0073,
  [-2.43] = 0.0075,
  [-2.42] = 0.0078,
  [-2.41] = 0.008,
  [-2.4] = 0.0082,
  [-2.39] = 0.0084,
  [-2.38] = 0.0087,
  [-2.37] = 0.0089,
  [-2.36] = 0.0091,
  [-2.35] = 0.0094,
  [-2.34] = 0.0096,
  [-2.33] = 0.0099,
  [-2.32] = 0.0102,
  [-2.31] = 0.0104,
  [-2.3] = 0.0107,
  [-2.29] = 0.011,
  [-2.28] = 0.0113,
  [-2.27] = 0.0116,
  [-2.26] = 0.0119,
  [-2.25] = 0.0122,
  [-2.24] = 0.0125,
  [-2.23] = 0.0129,
  [-2.22] = 0.0132,
  [-2.21] = 0.0136,
  [-2.2] = 0.0139,
  [-2.19] = 0.0143,
  [-2.18] = 0.0146,
  [-2.17] = 0.015,
  [-2.16] = 0.0154,
  [-2.15] = 0.0158,
  [-2.14] = 0.0162,
  [-2.13] = 0.0166,
  [-2.12] = 0.017,
  [-2.11] = 0.0174,
  [-2.1] = 0.0179,
  [-2.09] = 0.0183,
  [-2.08] = 0.0188,
  [-2.07] = 0.0192,
  [-2.06] = 0.0197,
  [-2.05] = 0.0202,
  [-2.04] = 0.0207,
  [-2.03] = 0.0212,
  [-2.02] = 0.0217,
  [-2.01] = 0.0222,
  [-2.0] = 0.0228,
  [-1.99] = 0.0233,
  [-1.98] = 0.0239,
  [-1.97] = 0.0244,
  [-1.96] = 0.025,
  [-1.95] = 0.0256,
  [-1.94] = 0.0262,
  [-1.93] = 0.0268,
  [-1.92] = 0.0274,
  [-1.91] = 0.0281,
  [-1.9] = 0.0287,
  [-1.89] = 0.0294,
  [-1.88] = 0.0301,
  [-1.87] = 0.0307,
  [-1.86] = 0.0314,
  [-1.85] = 0.0322,
  [-1.84] = 0.0329,
  [-1.83] = 0.0336,
  [-1.82] = 0.0344,
  [-1.81] = 0.0351,
  [-1.8] = 0.0359,
  [-1.79] = 0.0367,
  [-1.78] = 0.0375,
  [-1.77] = 0.0384,
  [-1.76] = 0.0392,
  [-1.75] = 0.0401,
  [-1.74] = 0.0409,
  [-1.73] = 0.0418,
  [-1.72] = 0.0427,
  [-1.71] = 0.0436,
  [-1.7] = 0.0446,
  [-1.69] = 0.0455,
  [-1.68] = 0.0465,
  [-1.67] = 0.0475,
  [-1.66] = 0.0485,
  [-1.65] = 0.0495,
  [-1.64] = 0.0505,
  [-1.63] = 0.0516,
  [-1.62] = 0.0526,
  [-1.61] = 0.0537,
  [-1.6] = 0.0548,
  [-1.59] = 0.0559,
  [-1.58] = 0.0571,
  [-1.57] = 0.0582,
  [-1.56] = 0.0594,
  [-1.55] = 0.0606,
  [-1.54] = 0.0618,
  [-1.53] = 0.063,
  [-1.52] = 0.0643,
  [-1.51] = 0.0655,
  [-1.5] = 0.0668,
  [-1.49] = 0.0681,
  [-1.48] = 0.0694,
  [-1.47] = 0.0708,
  [-1.46] = 0.0721,
  [-1.45] = 0.0735,
  [-1.44] = 0.0749,
  [-1.43] = 0.0764,
  [-1.42] = 0.0778,
  [-1.41] = 0.0793,
  [-1.4] = 0.0808,
  [-1.39] = 0.0823,
  [-1.38] = 0.0838,
  [-1.37] = 0.0853,
  [-1.36] = 0.0869,
  [-1.35] = 0.0885,
  [-1.34] = 0.0901,
  [-1.33] = 0.0918,
  [-1.32] = 0.0934,
  [-1.31] = 0.0951,
  [-1.3] = 0.0968,
  [-1.29] = 0.0985,
  [-1.28] = 0.1003,
  [-1.27] = 0.102,
  [-1.26] = 0.1038,
  [-1.25] = 0.1056,
  [-1.24] = 0.1075,
  [-1.23] = 0.1093,
  [-1.22] = 0.1112,
  [-1.21] = 0.1131,
  [-1.2] = 0.1151,
  [-1.19] = 0.117,
  [-1.18] = 0.119,
  [-1.17] = 0.121,
  [-1.16] = 0.123,
  [-1.15] = 0.1251,
  [-1.14] = 0.1271,
  [-1.13] = 0.1292,
  [-1.12] = 0.1314,
  [-1.11] = 0.1335,
  [-1.1] = 0.1357,
  [-1.09] = 0.1379,
  [-1.08] = 0.1401,
  [-1.07] = 0.1423,
  [-1.06] = 0.1446,
  [-1.05] = 0.1469,
  [-1.04] = 0.1492,
  [-1.03] = 0.1515,
  [-1.02] = 0.1539,
  [-1.01] = 0.1562,
  [-1.0] = 0.1587,
  [-0.99] = 0.1611,
  [-0.98] = 0.1635,
  [-0.97] = 0.166,
  [-0.96] = 0.1685,
  [-0.95] = 0.1711,
  [-0.94] = 0.1736,
  [-0.93] = 0.1762,
  [-0.92] = 0.1788,
  [-0.91] = 0.1814,
  [-0.9] = 0.1841,
  [-0.89] = 0.1867,
  [-0.88] = 0.1894,
  [-0.87] = 0.1922,
  [-0.86] = 0.1949,
  [-0.85] = 0.1977,
  [-0.84] = 0.2005,
  [-0.83] = 0.2033,
  [-0.82] = 0.2061,
  [-0.81] = 0.209,
  [-0.8] = 0.2119,
  [-0.79] = 0.2148,
  [-0.78] = 0.2177,
  [-0.77] = 0.2206,
  [-0.76] = 0.2236,
  [-0.75] = 0.2266,
  [-0.74] = 0.2296,
  [-0.73] = 0.2327,
  [-0.72] = 0.2358,
  [-0.71] = 0.2389,
  [-0.7] = 0.242,
  [-0.69] = 0.2451,
  [-0.68] = 0.2483,
  [-0.67] = 0.2514,
  [-0.66] = 0.2546,
  [-0.65] = 0.2578,
  [-0.64] = 0.2611,
  [-0.63] = 0.2643,
  [-0.62] = 0.2676,
  [-0.61] = 0.2709,
  [-0.6] = 0.2743,
  [-0.59] = 0.2776,
  [-0.58] = 0.281,
  [-0.57] = 0.2843,
  [-0.56] = 0.2877,
  [-0.55] = 0.2912,
  [-0.54] = 0.2946,
  [-0.53] = 0.2981,
  [-0.52] = 0.3015,
  [-0.51] = 0.305,
  [-0.5] = 0.3085,
  [-0.49] = 0.3121,
  [-0.48] = 0.3156,
  [-0.47] = 0.3192,
  [-0.46] = 0.3228,
  [-0.45] = 0.3264,
  [-0.44] = 0.33,
  [-0.43] = 0.3336,
  [-0.42] = 0.3372,
  [-0.41] = 0.3409,
  [-0.4] = 0.3446,
  [-0.39] = 0.3483,
  [-0.38] = 0.352,
  [-0.37] = 0.3557,
  [-0.36] = 0.3594,
  [-0.35] = 0.3632,
  [-0.34] = 0.3669,
  [-0.33] = 0.3707,
  [-0.32] = 0.3745,
  [-0.31] = 0.3783,
  [-0.3] = 0.3821,
  [-0.29] = 0.3859,
  [-0.28] = 0.3897,
  [-0.27] = 0.3936,
  [-0.26] = 0.3974,
  [-0.25] = 0.4013,
  [-0.24] = 0.4052,
  [-0.23] = 0.409,
  [-0.22] = 0.4129,
  [-0.21] = 0.4168,
  [-0.2] = 0.4207,
  [-0.19] = 0.4247,
  [-0.18] = 0.4286,
  [-0.17] = 0.4325,
  [-0.16] = 0.4364,
  [-0.15] = 0.4404,
  [-0.14] = 0.4443,
  [-0.13] = 0.4483,
  [-0.12] = 0.4522,
  [-0.11] = 0.4562,
  [-0.1] = 0.4602,
  [-0.09] = 0.4641,
  [-0.08] = 0.4681,
  [-0.07] = 0.4721,
  [-0.06] = 0.4761,
  [-0.05] = 0.4801,
  [-0.04] = 0.484,
  [-0.03] = 0.488,
  [-0.02] = 0.492,
  [-0.01] = 0.496,
  [-0.0] = 0.5,
  [0.01] = 0.504,
  [0.02] = 0.508,
  [0.03] = 0.512,
  [0.04] = 0.516,
  [0.05] = 0.5199,
  [0.06] = 0.5239,
  [0.07] = 0.5279,
  [0.08] = 0.5319,
  [0.09] = 0.5359,
  [0.1] = 0.5398,
  [0.11] = 0.5438,
  [0.12] = 0.5478,
  [0.13] = 0.5517,
  [0.14] = 0.5557,
  [0.15] = 0.5596,
  [0.16] = 0.5636,
  [0.17] = 0.5675,
  [0.18] = 0.5714,
  [0.19] = 0.5753,
  [0.2] = 0.5793,
  [0.21] = 0.5832,
  [0.22] = 0.5871,
  [0.23] = 0.591,
  [0.24] = 0.5948,
  [0.25] = 0.5987,
  [0.26] = 0.6026,
  [0.27] = 0.6064,
  [0.28] = 0.6103,
  [0.29] = 0.6141,
  [0.3] = 0.6179,
  [0.31] = 0.6217,
  [0.32] = 0.6255,
  [0.33] = 0.6293,
  [0.34] = 0.6331,
  [0.35] = 0.6368,
  [0.36] = 0.6406,
  [0.37] = 0.6443,
  [0.38] = 0.648,
  [0.39] = 0.6517,
  [0.4] = 0.6554,
  [0.41] = 0.6591,
  [0.42] = 0.6628,
  [0.43] = 0.6664,
  [0.44] = 0.67,
  [0.45] = 0.6736,
  [0.46] = 0.6772,
  [0.47] = 0.6808,
  [0.48] = 0.6844,
  [0.49] = 0.6879,
  [0.5] = 0.6915,
  [0.51] = 0.695,
  [0.52] = 0.6985,
  [0.53] = 0.7019,
  [0.54] = 0.7054,
  [0.55] = 0.7088,
  [0.56] = 0.7123,
  [0.57] = 0.7157,
  [0.58] = 0.719,
  [0.59] = 0.7224,
  [0.6] = 0.7257,
  [0.61] = 0.7291,
  [0.62] = 0.7324,
  [0.63] = 0.7357,
  [0.64] = 0.7389,
  [0.65] = 0.7422,
  [0.66] = 0.7454,
  [0.67] = 0.7486,
  [0.68] = 0.7517,
  [0.69] = 0.7549,
  [0.7] = 0.758,
  [0.71] = 0.7611,
  [0.72] = 0.7642,
  [0.73] = 0.7673,
  [0.74] = 0.7704,
  [0.75] = 0.7734,
  [0.76] = 0.7764,
  [0.77] = 0.7794,
  [0.78] = 0.7823,
  [0.79] = 0.7852,
  [0.8] = 0.7881,
  [0.81] = 0.791,
  [0.82] = 0.7939,
  [0.83] = 0.7967,
  [0.84] = 0.7995,
  [0.85] = 0.8023,
  [0.86] = 0.8051,
  [0.87] = 0.8078,
  [0.88] = 0.8106,
  [0.89] = 0.8133,
  [0.9] = 0.8159,
  [0.91] = 0.8186,
  [0.92] = 0.8212,
  [0.93] = 0.8238,
  [0.94] = 0.8264,
  [0.95] = 0.8289,
  [0.96] = 0.8315,
  [0.97] = 0.834,
  [0.98] = 0.8365,
  [0.99] = 0.8389,
  [1.0] = 0.8413,
  [1.01] = 0.8438,
  [1.02] = 0.8461,
  [1.03] = 0.8485,
  [1.04] = 0.8508,
  [1.05] = 0.8531,
  [1.06] = 0.8554,
  [1.07] = 0.8577,
  [1.08] = 0.8599,
  [1.09] = 0.8621,
  [1.1] = 0.8643,
  [1.11] = 0.8665,
  [1.12] = 0.8686,
  [1.13] = 0.8708,
  [1.14] = 0.8729,
  [1.15] = 0.8749,
  [1.16] = 0.877,
  [1.17] = 0.879,
  [1.18] = 0.881,
  [1.19] = 0.883,
  [1.2] = 0.8849,
  [1.21] = 0.8869,
  [1.22] = 0.8888,
  [1.23] = 0.8907,
  [1.24] = 0.8925,
  [1.25] = 0.8944,
  [1.26] = 0.8962,
  [1.27] = 0.898,
  [1.28] = 0.8997,
  [1.29] = 0.9015,
  [1.3] = 0.9032,
  [1.31] = 0.9049,
  [1.32] = 0.9066,
  [1.33] = 0.9082,
  [1.34] = 0.9099,
  [1.35] = 0.9115,
  [1.36] = 0.9131,
  [1.37] = 0.9147,
  [1.38] = 0.9162,
  [1.39] = 0.9177,
  [1.4] = 0.9192,
  [1.41] = 0.9207,
  [1.42] = 0.9222,
  [1.43] = 0.9236,
  [1.44] = 0.9251,
  [1.45] = 0.9265,
  [1.46] = 0.9279,
  [1.47] = 0.9292,
  [1.48] = 0.9306,
  [1.49] = 0.9319,
  [1.5] = 0.9332,
  [1.51] = 0.9345,
  [1.52] = 0.9357,
  [1.53] = 0.937,
  [1.54] = 0.9382,
  [1.55] = 0.9394,
  [1.56] = 0.9406,
  [1.57] = 0.9418,
  [1.58] = 0.9429,
  [1.59] = 0.9441,
  [1.6] = 0.9452,
  [1.61] = 0.9463,
  [1.62] = 0.9474,
  [1.63] = 0.9484,
  [1.64] = 0.9495,
  [1.65] = 0.9505,
  [1.66] = 0.9515,
  [1.67] = 0.9525,
  [1.68] = 0.9535,
  [1.69] = 0.9545,
  [1.7] = 0.9554,
  [1.71] = 0.9564,
  [1.72] = 0.9573,
  [1.73] = 0.9582,
  [1.74] = 0.9591,
  [1.75] = 0.9599,
  [1.76] = 0.9608,
  [1.77] = 0.9616,
  [1.78] = 0.9625,
  [1.79] = 0.9633,
  [1.8] = 0.9641,
  [1.81] = 0.9649,
  [1.82] = 0.9656,
  [1.83] = 0.9664,
  [1.84] = 0.9671,
  [1.85] = 0.9678,
  [1.86] = 0.9686,
  [1.87] = 0.9693,
  [1.88] = 0.9699,
  [1.89] = 0.9706,
  [1.9] = 0.9713,
  [1.91] = 0.9719,
  [1.92] = 0.9726,
  [1.93] = 0.9732,
  [1.94] = 0.9738,
  [1.95] = 0.9744,
  [1.96] = 0.975,
  [1.97] = 0.9756,
  [1.98] = 0.9761,
  [1.99] = 0.9767,
  [2.0] = 0.9772,
  [2.01] = 0.9778,
  [2.02] = 0.9783,
  [2.03] = 0.9788,
  [2.04] = 0.9793,
  [2.05] = 0.9798,
  [2.06] = 0.9803,
  [2.07] = 0.9808,
  [2.08] = 0.9812,
  [2.09] = 0.9817,
  [2.1] = 0.9821,
  [2.11] = 0.9826,
  [2.12] = 0.983,
  [2.13] = 0.9834,
  [2.14] = 0.9838,
  [2.15] = 0.9842,
  [2.16] = 0.9846,
  [2.17] = 0.985,
  [2.18] = 0.9854,
  [2.19] = 0.9857,
  [2.2] = 0.9861,
  [2.21] = 0.9864,
  [2.22] = 0.9868,
  [2.23] = 0.9871,
  [2.24] = 0.9875,
  [2.25] = 0.9878,
  [2.26] = 0.9881,
  [2.27] = 0.9884,
  [2.28] = 0.9887,
  [2.29] = 0.989,
  [2.3] = 0.9893,
  [2.31] = 0.9896,
  [2.32] = 0.9898,
  [2.33] = 0.9901,
  [2.34] = 0.9904,
  [2.35] = 0.9906,
  [2.36] = 0.9909,
  [2.37] = 0.9911,
  [2.38] = 0.9913,
  [2.39] = 0.9916,
  [2.4] = 0.9918,
  [2.41] = 0.992,
  [2.42] = 0.9922,
  [2.43] = 0.9925,
  [2.44] = 0.9927,
  [2.45] = 0.9929,
  [2.46] = 0.9931,
  [2.47] = 0.9932,
  [2.48] = 0.9934,
  [2.49] = 0.9936,
  [2.5] = 0.9938,
  [2.51] = 0.994,
  [2.52] = 0.9941,
  [2.53] = 0.9943,
  [2.54] = 0.9945,
  [2.55] = 0.9946,
  [2.56] = 0.9948,
  [2.57] = 0.9949,
  [2.58] = 0.9951,
  [2.59] = 0.9952,
  [2.6] = 0.9953,
  [2.61] = 0.9955,
  [2.62] = 0.9956,
  [2.63] = 0.9957,
  [2.64] = 0.9959,
  [2.65] = 0.996,
  [2.66] = 0.9961,
  [2.67] = 0.9962,
  [2.68] = 0.9963,
  [2.69] = 0.9964,
  [2.7] = 0.9965,
  [2.71] = 0.9966,
  [2.72] = 0.9967,
  [2.73] = 0.9968,
  [2.74] = 0.9969,
  [2.75] = 0.997,
  [2.76] = 0.9971,
  [2.77] = 0.9972,
  [2.78] = 0.9973,
  [2.79] = 0.9974,
  [2.8] = 0.9974,
  [2.81] = 0.9975,
  [2.82] = 0.9976,
  [2.83] = 0.9977,
  [2.84] = 0.9977,
  [2.85] = 0.9978,
  [2.86] = 0.9979,
  [2.87] = 0.9979,
  [2.88] = 0.998,
  [2.89] = 0.9981,
  [2.9] = 0.9981,
  [2.91] = 0.9982,
  [2.92] = 0.9982,
  [2.93] = 0.9983,
  [2.94] = 0.9984,
  [2.95] = 0.9984,
  [2.96] = 0.9985,
  [2.97] = 0.9985,
  [2.98] = 0.9986,
  [2.99] = 0.9986,
  [3.0] = 0.9987,
}

-- Reported data keys.
KEY_CATCH = "catch"
KEY_WILD = "wild"
KEY_BATTLE = "battle"

VALUE_SUCCESS =  1
VALUE_FAILURE = -1

-- Roll Data.
roll_data = { }

-- Reported Data.
reported_data = { }

function onSave()
  local save_table = {
    roll_data=roll_data,
    reported_data=reported_data
  }
  return JSON.encode(save_table)
end

function onLoad(saved_data)
  -- Make this object not interactable.
  self.interactable = false
  self.setLock(true)
  self.setPosition({97.38, 1.96, 70.10})
  self.setRotation({0, 180, 0})

  local save_table
  if saved_data and saved_data ~= "" then
    save_table = JSON.decode(saved_data)
  end

  if save_table then
    roll_data=save_table.roll_data
    reported_data=save_table.reported_data
  end

  -- Do some safety checks.
  if roll_data == nil then
    roll_data = {}
  end
  if reported_data == nil then
    reported_data = {}
  end
  
  -- Create the button on top of the object to print current data.
  -- Left-click prints data to everone. Right-click prints data to self only.
  self.createButton({
    label="Print Roll Data",
    click_function="print_dice_rolls",
    function_owner=self,
    tooltip="Click to see roll your data",
    position={0, 0.5, 0},
    height=300,
    width=1350,
    font_size=200,
    color="White"
  })
end

-- Params:
--  TODO
function add_to_reported_data(params)
  -- Check that the type table exists.
end

function get_reported_data(player)

end

-- Params:
--  dice_type
--    whited6
--    redd6
--    d8
--    d4
--    movement
--  value
--  player_name
function record_dice_roll(params)
  -- Sanitizie the inputs.
  if params == nil then
    print("Record Keeper is rejecting data because no data was given; required: player_name, dice_type, value")
    return
  end
  if params.player_name == nil or params.dice_type == nil or params.value == nil then
    local data = {
      player_name = params.player_name or "nil",
      dice_type = params.dice_type or "nil",
      value = params.value or "nil"
    }
    print("Record Keeper is rejecting new data because data is missing: " .. dump_table(data))
    return
  end
  if type(params.value) ~= "number" then
    print("Record Keeper is rejecting new data because the value is not a number: " .. tostring(params.value))
    return
  end

  -- Ensure everything is a table.
  if roll_data[params.player_name] == nil then
    roll_data[params.player_name] = {}
  end
  if roll_data[params.player_name][params.dice_type] == nil then
    roll_data[params.player_name][params.dice_type] = {}
  end

  -- Insert the data.
  table.insert(roll_data[params.player_name][params.dice_type], params.value)
end

-- Fucntion to handle external requests for data.
function handle_roll_stats_request(params)
  -- Check for params.
  if params == nil or params.color == nil then return end

  print_dice_rolls(nil, params.color, nil)
end

-- Function called when clicking the button above the Record Keeper.
function print_dice_rolls(obj, color, alt)
  -- Get the roll data for the player.
  local data = get_roll_data(color, nil)

  -- Check for data.
  if data == nil or data.roll_data == nil then
    -- get_roll_data() will log data not found.
    return
  end

  -- Print the data.
  printToAll(data.player .. "'s roll data:", color)
  for data_key, roll_table in pairs(data.roll_data) do
    local roll_type = data_key
    if SANITIZED_ROLL_TYPES[roll_type] ~= nil then
      roll_type = SANITIZED_ROLL_TYPES[roll_type]
    end

    -- Print the roll type.
    printToAll("  " .. tostring(roll_type) .. " (" .. tostring(roll_table.total) .. "):")
    
    -- Loop through metrics.
    for metric_key, value in pairs(roll_table) do
      if metric_key ~= "total" then
        if type(value) ~= "number" then value = 0 end
        printToAll("    " .. metric_key .. ": " .. tostring(value):sub(1,4))
      end
    end
    local percentile = get_percentile(data_key, roll_table)
    printToAll("    percentile: " .. tostring(percentile) .. "%")
  end
end

-- Returns a table with the player name and all recorded roll data in roll_data.
function get_roll_data(player, type, alt)
  -- Try to get the proper player name. player should just be the color.
  local color = player
  if roll_data[player] == nil then
    if Player[player] ~= nil then
      player = Player[player].steam_name
    end
  end

  -- If player is still nil then just return.
  if player == nil then
    printToAll("Failed to find player: " .. tostring(color))
    return { player = player }
  end

  -- Check if there is data.
  if roll_data[player] == nil then
    printToAll("No roll data found for " .. player)
    return { player = player }
  end
  if type ~= nil and roll_data[player][type] == nil then
    printToAll("No " .. tostring(type) .. " roll data found for " .. player)
    return { player = player }
  end

  -- Print the roll data.
  if type ~= nil then
    -- Return only the roll data of one type.
    return get_table_data(roll_data[player][type])
  else
    -- Return all roll data for this player.
    local return_table = {}
    return_table.roll_data = {}
    for key, roll_table in pairs(roll_data[player]) do
      return_table.roll_data[key] = get_table_data(roll_table)
    end

    -- Include the actual player name in the data.
    return_table.player = player

    -- Return the data.
    return return_table
  end
end

-- Helper function to get the mean of a table of values.
function get_mean(input_table)
  -- Ensure the data is a table.
  if type(input_table) ~= "table" then
    print("Cannot get sum for input parameter: not a table")
    return
  end

  -- Init some variables.
  local sum = 0
  local count= 0

  for k,v in pairs(input_table) do
    if type(v) == 'number' then
      sum = sum + v
      count = count + 1
    end
  end

  return (sum / count)
end

-- Helper function to get the standard deviation of a table of values.
function get_std_deviation(input_table)
  -- Ensure the data is a table.
  if type(input_table) ~= "table" then
    print("Cannot get sum for input parameter: not a table")
    return
  end

  -- Init some values.
  local vm
  local sum
  local sum = 0
  local count = 0
  local m = get_mean(input_table)

  -- Calculate.
  for k, v in pairs(input_table) do
    if type(v) == 'number' then
      vm = v - m
      sum = sum + (vm * vm)
      count = count + 1
    end
  end

  local result = math.sqrt(sum / (count-1))
  return result
end

-- Helper function to get the percentile for a dice roll average.
function get_percentile(roll_type, roll_table)
  -- Ensure the data is a table.
  if type(roll_table) ~= "table" then
    print("Cannot get percentiles for input parameter: not a table")
    return
  end

  -- Get constant data about this roll type.
  local constants = PERCENTILE_HELPER_TABLE[roll_type]

  -- Get the average standard deviation for this roll type and count.
  local average_std_dev = get_average_standard_deviation(constants.std_dev, roll_table.total)

  -- Calculate the z-score.
  local z_score = (roll_table.mean - constants.avg) / average_std_dev
  z_score = tonumber(string.format("%.2f", z_score))

  -- Get the percentile.
  return tonumber(string.format("%.0f", Z_SCORES[z_score] * 100))
end

-- Helper function to get average of the average roll.
function get_average_standard_deviation(std_deviation, count)
  return std_deviation / (math.sqrt(count))
end

-- Helper function to get the average and total of all values in a table.
-- Returns table with mean, std_dev and total.
function get_table_data(input_table)
  -- Ensure the data is a table.
  if type(input_table) ~= "table" then
    print("Cannot get metrics for input parameter: not a table")
    return
  end

  -- Return the data.
  local data = {
    mean = get_mean(input_table),
    std_dev = get_std_deviation(input_table),
    total = #input_table
  }
  return data
end

-- Helper function to print a table.
function dump_table(o)
  if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump_table(v) .. ','
      end
      return s .. '} '
  else
      return tostring(o)
  end
end