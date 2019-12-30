from bs4 import BeautifulSoup
import requests

def getSpanList(region):
	res = requests.get("https://www.smashbros.com/%s/stage/index.html" % region)
	soup = BeautifulSoup(res.content)
	ret = soup.findAll(name="span", attrs={"class" :"stage-box__name-label"})
	return ret

EN = []
CN = []
JP = []

if __name__ == "__main__":
	ret = getSpanList("en_US")
	for item in ret:
		EN.append(item.string)

	ret = getSpanList("SC")
	for item in ret:
		CN.append(item.string)

	ret = getSpanList("ja_JP")
	for item in ret:
		JP.append(item.string)

	f = open("sample.plist","w",encoding = 'UTF-8')
	for index in range(len(CN)):
		f.write("\t<dict>\n")
		f.write("\t\t<key>picDir</key>\n")
		f.write("\t\t<string>Stage%d.jpg</string>\n" % int(index + 1))
		f.write("\t\t<key>EN</key>\n")
		f.write("\t\t<string>%s</string>\n" % EN[index])
		f.write("\t\t<key>CN</key>\n")
		f.write("\t\t<string>%s</string>\n" % CN[index])
		f.write("\t\t<key>JP</key>\n")
		f.write("\t\t<string>%s</string>\n" % JP[index])
		f.write("\t</dict>\n")
	f.close()