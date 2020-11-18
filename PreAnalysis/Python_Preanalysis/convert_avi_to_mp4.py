from converter import Converter
conv = Converter()

info = conv.probe('/Users/madeleinesnyder/Documents/Berkeley/Bats/data/BatHumanExp/201010/cam/av.avi')

convert = conv.convert('/Users/madeleinesnyder/Documents/Berkeley/Bats/data/BatHumanExp/201010/cam/av.avi', '/Users/madeleinesnyder/Documents/Berkeley/Bats/data/BatHumanExp/201010/cam/av.mp4', {
    'format': 'mp4',
    'audio': {
        'codec': 'aac',
        'samplerate': 11025,
        'channels': 2
    },
    'video': {
        'codec': 'hevc',
        'width': 720,
        'height': 400,
        'fps': 25
    }})

for timecode in convert:
    print(f'\rConverting ({timecode:.2f}) ...')
