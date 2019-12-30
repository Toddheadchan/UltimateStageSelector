import requests

# download the picture
def printPic(url,index):

	fileName = "Stage%d.jpg" % index
	r = requests.get(url)
	r.raise_for_status
	f = open(fileName,"wb")
	f.write(r.content)

if __name__ == "__main__":
	for i in range(1,104):
		printPic("https://www.smashbros.com/assets_v2/img/stage/stage_img%d.jpg" % i, i)