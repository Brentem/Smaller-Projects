module snake;
import raylib5::rl;

const int BLOCK_WIDTH = 16;
const int BLOCK_HEIGHT = 16;

const int BLOCK_COUNT_HORIZONTAL = 64;
const int BLOCK_COUNT_VERTICAL = 48;

const int SCREEN_WIDTH = (BLOCK_WIDTH * BLOCK_COUNT_HORIZONTAL);
const int SCREEN_HEIGHT = (BLOCK_HEIGHT * BLOCK_COUNT_VERTICAL);

// NOTE: See difference in declaring and accessing 2d array.
int[BLOCK_COUNT_HORIZONTAL][BLOCK_COUNT_VERTICAL] grid;

double prev_time;
double curr_time;
int player_x_index = (BLOCK_COUNT_HORIZONTAL / 2);
int player_y_index = (BLOCK_COUNT_VERTICAL / 2);
bool moving_horizontally = false;

fn int main()
{
    rl::initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Snake");
    rl::setTargetFPS(60);

	grid[player_y_index][player_x_index] = 1;
	prev_time = rl::getTime();

    while (!rl::windowShouldClose())
    {
		curr_time = rl::getTime();
		if((curr_time - prev_time) >= 0.3)
		{
			prev_time = curr_time;
			grid[player_y_index][player_x_index] = 0;

			// TODO: Consider creating a state machine to handle different directions.
			// TODO: Also check if index is valid.
			if(!moving_horizontally)
			{
				player_y_index++;
				grid[player_y_index][player_x_index] = 1;
			}
		}


        rl::clearBackground(rl::BLACK);

        rl::beginDrawing();
		{
			for(int y = 0; y < BLOCK_COUNT_VERTICAL; y++)
			{
				for(int x = 0; x < BLOCK_COUNT_HORIZONTAL; x++)
				{
					if(grid[y][x] == 1)
					{
						// Draw Player
						int posX = x * BLOCK_WIDTH;
						int posY = y * BLOCK_HEIGHT;
						rl::drawRectangle(posX, posY, BLOCK_WIDTH, BLOCK_HEIGHT, rl::GREEN); // Head of snake
					}
				}
			}
		}
        rl::endDrawing();
    }

    rl::closeWindow();

    return 0;
}
