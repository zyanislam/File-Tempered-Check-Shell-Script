import random
import os
import sys

if __name__ == "__main__":
    file_count = int(sys.argv[1])
    created = 0
    day, month, year = -1, -1, -1
    depatments = ['cse', 'eee', 'civil', 'mecha']

    while created < file_count:
        day = random.randrange(1, 31)
        month = random.randrange(1, 13)
        year = random.randrange(2000, 2022)
        dept = random.choice(depatments)

        directory = f'logs/{dept}/'
        if not os.path.exists(directory):
            os.makedirs(directory)

        filename = f'{year:04d}_{month:02d}_{day:02d}.log'
        filepath = directory + filename
        print(filepath)
        if os.path.exists(filename):
            continue

        probs = [random.uniform(0, 1) for _ in range(4)]
        for i, prob in enumerate(probs):
            if prob > 0.75:
                if i == 0: day = random.randrange(1, 31)
                if i == 1: month = random.randrange(1, 13)
                if i == 2: year = random.randrange(2000, 2022)
                if i == 3: dept = random.choice(depatments)
        
        with open(filepath, 'w') as f:
            f.write(f"Department: {dept}\n")
            f.write(f"Log for {year:04d}_{month:02d}_{day:02d}")

        created += 1
        
            


