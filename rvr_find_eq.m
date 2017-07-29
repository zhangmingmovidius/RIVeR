function param=rvr_find_eq(pt_1,pt_2)

 param=polyfit([pt_1(1);pt_2(1)],[pt_1(2);pt_2(2)],1);