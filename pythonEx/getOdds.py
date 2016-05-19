#! /usr/bin/python
# getOdds.py

p = 1
q = 10

print "Get Evens!"
#def getEvens (p, q):
#""" returns a string of even numbers between integers p & q """
x = p
while x <= q:
	if x % 2 != 0:
		x += 1
	else:
		# Calculate & print string
		#print(x, end=", ")         # python 3.x
		print x,                    # python 2.x
		str(x).strip(", ")
		x += 2

print ""
print "Now Get Odds!"
#def getOdds (p, q):
#""" returns a string of odd numbers between integers p & q """
# Define odd number string
x = p
while x <= q:
	if x % 2 == 0:
		x += 1
	else:
		# Calculate & print string
		#print(x, end=", ")         # python 3.x
		print x,                    # python 2.x
		str(x).strip(", ")
		x += 2

