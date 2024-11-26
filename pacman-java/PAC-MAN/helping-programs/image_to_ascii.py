from PIL import Image

# Function to map grayscale values to ASCII characters
def pixel_to_ascii(pixel_value):
    ascii_chars = "@%#*+=-:. "  # From darkest to lightest
    return ascii_chars[int(pixel_value / 255 * (len(ascii_chars) - 1))]

# Function to resize the image while maintaining the aspect ratio
def resize_image(image, new_width, new_height=None):
    width, height = image.size
    aspect_ratio = height / width
    if new_height is None:
        new_height = int(new_width * aspect_ratio)
    
    # Adjust for the fact that ASCII characters are taller than they are wide
    ascii_character_ratio = 2  # Adjust this value as needed
    new_height = int(new_height * ascii_character_ratio)

    return image.resize((new_width, new_height))

# Function to convert the image to ASCII art
def image_to_ascii(image_path, width=680, height=650):
    try:
        # Open the image file
        image = Image.open(image_path)
    except Exception as e:
        print(f"Error opening image: {e}")
        return

    # Resize image to the specified dimensions
    image = resize_image(image, width, height)
    
    # Convert image to grayscale
    grayscale_image = image.convert("L")
    
    # Create the ASCII art
    ascii_art = []
    for y in range(grayscale_image.height):
        row = ""
        for x in range(grayscale_image.width):
            pixel_value = grayscale_image.getpixel((x, y))
            row += pixel_to_ascii(pixel_value)
        ascii_art.append(row)
    
    return "\n".join(ascii_art)

# Function to save the ASCII art to a file
def save_ascii_to_file(ascii_art, filename="output_ascii.txt"):
    try:
        with open(filename, 'w') as f:
            f.write(ascii_art)
        print(f"ASCII art saved to {filename}")
    except Exception as e:
        print(f"Error saving file: {e}")

# Example usage
if __name__ == "__main__":
    image_path = "Originalpacmaze.webp"  # Change this to your image file path
    width = 80  # Customize the width
    height = 40  # Optional: Customize the height or leave it as None for auto scaling

    ascii_art = image_to_ascii(image_path, width, height)
    if ascii_art:
        print(ascii_art)
        save_ascii_to_file(ascii_art, "ascii_image.txt")
