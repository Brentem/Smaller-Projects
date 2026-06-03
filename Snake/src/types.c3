enum InputEvent
{
	NO_INPUT_EVENT,
	INPUT_EVENT_KEY_RIGHT,
	INPUT_EVENT_KEY_LEFT
}

enum MovementDirection
{
	MOVING_UP,
	MOVING_DOWN,
	MOVING_RIGHT,
	MOVING_LEFT
}

enum BlockType
{
	NO_BLOCK,
	PLAYER_HEAD_BLOCK,
	PLAYER_BODY_BLOCK,
	FOOD_BLOCK,
	BORDER_BLOCK
}

struct SnakeBlock
{
	BlockType type;
	int x_index;
	int y_index;
}