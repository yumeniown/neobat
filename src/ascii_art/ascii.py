from PIL import Image, ImageDraw, ImageFont

chars = ["@", "#", "S", "%", "?", "*", "+", ";", ":", ",", "."]


def resize(image, new_width=80):
    width, height = image.size
    aspect_ratio = height/width
    new_height = int(aspect_ratio * new_width * 0.55)
    resized = image.resize((new_width, new_height))
    return resized

def grayify(image):
    return image.convert("L")

def pixels_to_ascii(image):
    pixels = image.getdata()
    ascii_str = "".join([chars[pixel // 25] for pixel in pixels])
    return ascii_str

def image_to_ascii(image_path, width=80):
    try:
        image = Image.open(image_path)
    except Exception as e:
        print(f"Can't open your image: {e}")
        return ""

    image = resize(image, width)
    image = grayify(image)
    ascii_str = pixels_to_ascii(image)

    img_width = image.width
    ascii_img = "\n".join([ascii_str[i:i+img_width] for i in range(0, len(ascii_str), img_width)])
    return ascii_img

if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Write python ascii.py <image_path> [width]")
        sys.exit(1)

    image_path = sys.argv[1]
    width = int(sys.argv[2]) if len(sys.argv) > 2 else 80

    ascii_art = image_to_ascii(image_path, width)
    print(ascii_art)

    with open("logo.txt", "w") as f:
        f.write(ascii_art)
