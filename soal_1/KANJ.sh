BEGIN{
    FS=","
    fileCsv = ARGV[1]
    soal = ARGV[2]
    
    if (soal != "a" && soal != "b" && soal != "c" && soal != "d" && soal != "e") {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh data.csv a"
        exit
    }
    delete ARGV[2]
    maxAge = 0
    maxName = ""
    
}
{
    jumlah++
    carriageCategory[$4] = 1
    if(max_age <= $2){
        maxName = $1
        maxAge = $2
    }
    sumAge += $2
    if($3 == "Business"){
        businessCount++
    }

    
}

END{
if(soal == "a"){
    print "Jumlah seluruh penumpang KANJ adalah" jumlah " orang"
}else if(soal == "b"){
    for(a in carriageCategory)countCarriage++
    print "Jumlah gerbong penumpang KANJ adalah" countCarriage
}else if(soal == "c"){
    print maxName " adalah penumpang kereta tertua dengan usia "maxAge" tahun"
}else if(soal == "d"){
    avarage = int(sumAge / jumlah)
    print "Rata-rata usia penumpang adalah " avarage " tahun"
}else if(soal == "e"){
    print "Jumlah penumpang business class ada "businessCount" orang"
}
}

