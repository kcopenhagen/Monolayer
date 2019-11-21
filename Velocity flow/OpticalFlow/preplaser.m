function l = preplaser(l1)
l1 = l1./imgaussfilt(l1,64);
l1 = imsharpen(l1,'Amount',3,'Radius',3);
l1 = imgaussfilt(l1,1);
l = normalise(l1);
