extends Sprite

#Array Object for all characters available
var charactersList = []

#Following variables represent current location of characters selection
var currentSelection = 0 # Spot of the cursor within the characters[]
var currentColumnSpot = 0 # Spot of the cursor based on the column
var currentRowSpot = 0 # Spot of the cursor based on the row

# Exports 
export (Texture) var player1Text    # Cursor Texture for  Player 1 is making choice
export (Texture) var player2Text    # Cursor Texture for  Player 2 is making choice
export (int) var amountOfRows = 2      # The total amount of rows the character select is able to show 
export (Vector2) var portraitOffset    # The distance between the portraits (change values manually)


# Objects
onready var gridContainer = get_parent().get_node("GridContainer")   # Gets the Gridcontainer

func _ready():
# Get all of the characters stored within the group "Characters" and place them in the Array characters
	for nameOfCharacter in get_tree().get_nodes_in_group("Characters"):
		charactersList.append(nameOfCharacter)
#	print(characters)
	texture = player1Text
	
	
# This whole _process(delta) function is used to allow scrolling through all the characters
func _process(_delta):
	if(Input.is_action_just_pressed("right")):
		currentSelection += 1
		currentColumnSpot += 1
		# If the cursor goes past the total amount of columns reset to the first item in the column and go 1 row down
		if(currentColumnSpot > gridContainer.columns - 1 && currentSelection < charactersList.size() - 1):
			position.x -= (currentColumnSpot - 1) * portraitOffset.x
			position.y += portraitOffset.y
			
			currentColumnSpot = 0
			currentRowSpot += 1
		# If the cursor goes past the total amount of columns and amount of characters, reset to the first item in the whole roster 
		elif(currentColumnSpot > gridContainer.columns - 1 && currentSelection > charactersList.size() - 1):
			position.x -= (currentColumnSpot - 1) * portraitOffset.x
			position.y -= currentRowSpot * portraitOffset.y
			
			currentColumnSpot = 0
			currentRowSpot = 0
			currentSelection = 0
		else:
			position.x += portraitOffset.x
	elif(Input.is_action_just_pressed("left")):
		currentSelection -= 1
		currentColumnSpot -= 1
		# If the cursor goes past the 0 amount on a column position reset to the first item in the column and go 1 row up
		if(currentColumnSpot < 0 && currentSelection > 0):
			position.x += (gridContainer.columns - 1) * portraitOffset.x
			position.y -= (amountOfRows - 1) * portraitOffset.y
			
			currentColumnSpot = gridContainer.columns - 1
			currentRowSpot -= 1
		# If the cursor goes past the 0 amount on a column position and 0 amount of characters, reset to the last item in the whole roster 
		elif (currentColumnSpot < 0 && currentSelection < 0):
			position.x += (gridContainer.columns - 1) * portraitOffset.x
			position.y += (amountOfRows - 1) * portraitOffset.y
			
			currentColumnSpot = gridContainer.columns - 1
			currentRowSpot = amountOfRows - 1
			currentSelection = charactersList.size() - 1
		else:
			position.x -= portraitOffset.x

# If a selection is made send it to the Signleton CharacterSelectionManager.gd to store that value
	if(Input.is_action_just_pressed("ui_accept")):
		if(CharacterSelectionController.player == null):
			CharacterSelectionController.player = CharacterSelectionController.selectableCharacters[charactersList[currentSelection].name]
			texture = player2Text
		else:
			CharacterSelectionController.opponent = CharacterSelectionController.selectableCharacters[charactersList[currentSelection].name]

