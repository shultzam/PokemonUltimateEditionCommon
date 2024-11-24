# Standard imports.
from pprint import pprint

def create_shiny_table(path: str):
    ''' This function returns a dict of count of each unique 'word' found in the file supplied. '''

    # Read the file into memory.
    shiny_table = []
    with open(path, 'r') as file:
        for line in file:
            # Tokenize.
            tokenized_string = line.split(',')

            # If this is a line we care about, collect the fields we want.
            tokenized_string = tokenized_string[0].split("\"")
            if len(tokenized_string) == 3:
                # Determine the Pokemon name.
                pokemon_name = tokenized_string[1]
                line = '[' + str(pokemon_name) + '"] = { guid = nil, shinyModelGuid = "yyyyyy" },'
                shiny_table.append(line)
            else:
                print('WARNING: skipping line: {}'.format(line))

    return shiny_table

if __name__ == '__main__':
    # Get the table.
    shiny_table = create_shiny_table(path='./temp_global.lua')
    with open('shiny_table.lua', 'wt') as file_out:
      pprint(shiny_table, stream=file_out)