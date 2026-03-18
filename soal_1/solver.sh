BEGIN {
    FS = ","
    soal = ARGV[2]
    delete ARGV[2]

    if (soal != "a" && soal != "b" && soal != "c" && soal != "d" && soal != "e") {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh passenger.csv a"
        exit
    }
}

NR == 1 {
    # Simpan posisi kolom berdasarkan header
    for (i = 1; i <= NF; i++) {
        h = tolower($i)
        gsub(/^"|"$/, "", h)
        gsub(/^[ \t]+|[ \t]+$/, "", h)

        if (h == "name" || h == "passenger_name" || h == "nama") name_col = i
        if (h == "age" || h == "umur") age_col = i
        if (h == "carriage" || h == "gerbong") carriage_col = i
        if (h == "class" || h == "kelas") class_col = i
    }
    next
}

{
    total_passenger++

    # Bersihkan data
    for (i = 1; i <= NF; i++) {
        gsub(/^"|"$/, "", $i)
        gsub(/^[ \t]+|[ \t]+$/, "", $i)
    }

    # b. jumlah gerbong unik
    if (carriage_col && $carriage_col != "") {
        carriage_seen[$carriage_col] = 1
    }

    # c dan d. data umur
    if (age_col && $age_col ~ /^[0-9]+$/) {
        age = $age_col + 0
        sum_age += age

        if (age > max_age) {
            max_age = age
            if (name_col) oldest_name = $name_col
            else oldest_name = "Tidak diketahui"
        }
    }

    # e. jumlah business class
    if (class_col) {
        kelas = tolower($class_col)
        if (kelas == "business" || kelas == "business class") {
            business_count++
        }
    }
}

END {
    if (soal == "a") {
        print "Jumlah seluruh penumpang KANJ adalah " total_passenger " orang"
    }
    else if (soal == "b") {
        count_carriage = 0
        for (c in carriage_seen) count_carriage++
        print "Jumlah gerbong penumpang KANJ adalah " count_carriage
    }
    else if (soal == "c") {
        print "Penumpang tertua adalah " oldest_name " dengan usia " max_age " tahun"
    }
    else if (soal == "d") {
        avg = (total_passenger > 0 ? sum_age / total_passenger : 0)
        print "Rata-rata usia penumpang adalah " int(avg + 0.5) " tahun"
    }
    else if (soal == "e") {
        print "Jumlah penumpang business class adalah " business_count " orang"
    }
}