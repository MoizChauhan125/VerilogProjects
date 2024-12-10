from PIL import Image

# Load the image
img = Image.open('C:/Users/MFAZEEL RAFIQ CHOHAN/Desktop/image.jpg')  # Replace with your image file path
img = img.resize((1024, 768))  # Ensure resolution matches
img = img.convert('RGB')       # Ensure it's in RGB format

# Extract RGB data
with open('image_data.txt', 'w') as f:
    for y in range(768):        # Loop through rows
        for x in range(1024):   # Loop through columns
            r, g, b = img.getpixel((x, y))
            f.write(f"{r:02X}{g:02X}{b:02X}\n") 