from PIL import Image

ascii_characters_by_surface = "`^\",:;Il!i~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$"
max_brightness = 255 * 3

def calculate_character_for_brightness(brightness):
    return ascii_characters_by_surface[int(brightness / max_brightness * len(ascii_characters_by_surface))]

def image_to_ascii(img_binary):
    output = "";

    with Image.open(img_binary) as img:
        width, height = img.size
        print(width, height)
        for y in range(0, height):
            for x in range(0, width):
                if x >= width - 1:
                    output += "\n"
                try:
                    r, g, b = img.getpixel((x, y))
                except ValueError:
                    r, g, b, *rest = img.getpixel((x, y))
                except TypeError:
                    return "Error: Image is not RGB"

                # Convert RGB to grayscale
                gray = int(0.2126 * r + 0.7152 * g + 0.0722 * b)
                # Return the grayscale value
                output += calculate_character_for_brightness(gray)

    return output