#!/usr/bin/env python
import math
from decimal import Decimal, ROUND_FLOOR

frequenz = 8*pow(10,6)	# 8 Mhz
vorteiler_liste = [1, 8, 32, 64, 128, 256, 1024]
timer = [8, 16]
s = Decimal(0.6)


t = Decimal(1/frequenz)				# taktperiode
for vorteiler in vorteiler_liste:
	print("#"*30)
	print("Vorteiler: %d" % vorteiler)
	k = vorteiler*t				# Dauer Timertick
	i = pow(2,timer[0])*k		# IRQ durch überlauf
	n = math.floor(s/i)				# Anzahl IRQs bis ms
	r = Decimal((s-n*i)/k).quantize(Decimal('0.00001'), rounding=ROUND_FLOOR)				# Anzahl restlicher IRQs
	print("t = %f ns" % (t*pow(10,9)))
	print("k = %f µs" % (k*pow(10,6)))
	print("i = %f ms" % (i*pow(10,3)))
	print("N = %d" % n)
	print("R = {}".format(r))
	print("s = %d - %d = %d" % (pow(2,timer[0])-1, r, pow(2,timer[0])-r-1))