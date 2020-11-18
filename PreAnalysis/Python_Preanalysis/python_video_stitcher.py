import cv2
import os

image_folder = '/Users/madeleinesnyder/Documents/Berkeley/Bats/data/BatHumanExp/201010/cam/session10'
video_name = 'session10_pyvid.avi'

images = [img for img in os.listdir(image_folder) if img.endswith(".tiff")]
frame = cv2.imread(os.path.join(image_folder, images[0]))
height, width, layers = frame.shape

video = cv2.VideoWriter(video_name, 0, 1, (width,height))

for image in images:
    video.write(cv2.imread(os.path.join(image_folder, image)))

cv2.destroyAllWindows()
video.release()
