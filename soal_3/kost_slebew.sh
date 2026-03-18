#!/bin/bash

showBanner() {
    echo ""
    echo "  ██╗  ██╗ ██████╗ ███████╗████████╗"
    echo "  ██║ ██╔╝██╔═══██╗██╔════╝╚══██╔══╝"
    echo "  █████╔╝ ██║   ██║███████╗   ██║   "
    echo "  ██╔═██╗ ██║   ██║╚════██║   ██║   "
    echo "  ██║  ██╗╚██████╔╝███████║   ██║   "
    echo "  ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
    echo "  ███████╗██╗     ███████╗██████╗ ███████╗██╗    ██╗"
    echo "  ██╔════╝██║     ██╔════╝██╔══██╗██╔════╝██║    ██║"
    echo "  ███████╗██║     █████╗  ██████╔╝█████╗  ██║ █╗ ██║"
    echo "  ╚════██║██║     ██╔══╝  ██╔══██╗██╔══╝  ██║███╗██║"
    echo "  ███████║███████╗███████╗██████╔╝███████╗╚███╔███╔╝"
    echo "  ╚══════╝╚══════╝╚══════╝╚═════╝ ╚══════╝ ╚══╝╚══╝ "
    echo ""
}

# ====== MENU UTAMA ======
showMenu() {
    showBanner
    echo "=========================================="
    echo "      SISTEM MANAJEMEN KOST SLEBEW"
    echo "=========================================="
    echo ""
    echo "  ID | OPTION"
    echo "  ----------------------------------------"
    echo "  1  | Tambah Penghuni Baru"
    echo "  2  | Hapus Penghuni"
    echo "  3  | Tampilkan Daftar Penghuni"
    echo "  4  | Update Status Penghuni"
    echo "  5  | Cetak Laporan Keuangan"
    echo "  6  | Kelola Cron (Pengingat Tagihan)"
    echo "  7  | Exit Program"
    echo "=========================================="
}


addMember(){
    echo "================================================"
    echo "             TAMBAH PENGHUNI"
    echo "================================================"
    read -rp "Masukan Nama: " nama
    read -rp "Masukan Kamar: " Kamar
    if awk -F',' -v k="$Kamar" '$2 == k {found = 1; exit} END {exit !found}' data/penghuni.csv; then        echo "Kamar $Kamar sudah terisi bro"
        return
    fi
    
    read -rp "Masukan harga sewa: " harga
    if [[ $harga -lt 0 ]]; then
        echo "harga tidak boleh minus"
        return
    fi
    
    read -rp "Masukan tanggal Masuk (YYYY-MM-DD):" tanggal
    if ! [[ "$tanggal" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Formatnya diperhatikan dekkk"
        return
    fi
    
    today=$(date +%Y-%m-%d)
    if [[ "$tanggal" > "$today" ]]; then
        echo "masak kamu dari masa depan sihh"
        
        return
    fi
    
    read -rp "Masuakn status awal (Aktif/Menunggak):" status
    
    echo "$nama,$Kamar,$harga,$tanggal,$status" >> data/penghuni.csv
    # echo "\n"
    echo "penghuni \"$nama\" berhasil ditambahkan ke Kamar $Kamar  dengan status $status"
    read -p "[press] untuk melanjutkan"
    clear
    
}

deleteMember(){
    echo "================================================"
    echo "             HAPUS PENGHUNI"
    echo "================================================"
    read -rp "Masukan nama yang ingin dihapus: " nama
    tanggalHapus=$(date +%Y-%m-%d)
    if [[ $nama == '' ]]; then
        echo "nama tidak boleh kosong"
        return
    fi
    grep -i "^$nama" data/penghuni.csv | while IFS= read -r line; do
        echo "$line,$tanggalHapus" >>  sampah/history_hapus.csv
    done
    
    grep -vi "^$nama" data/penghuni.csv >> data/penghuni.tmp | mv data/penghuni.tmp data/penghuni.csv
    
    echo "Data penghuni \"$nama\" berhasil diarsipkan ke sampah/history_hapus.csv dan dihapus dari sistem."
    read -p "[press] untuk melanjutkan"
    clear
    
}

showMember(){
    echo "========================================================================="
    echo "                           HAPUS PENGHUNI"
    echo "========================================================================="
    # printf " %-4s | %-15s | %-8s | %-10s | %-12s | %-10s \n" "NO" "Nama" "Kamar" "Harga" "Tanggal" "Status"
    printf " %-4s | %-15s | %-8s | %-10s | %-10s | %-10s \n-------------------------------------------------------------------------\n" "NO" "Nama" "Kamar" "Harga" "tanggal" "Status"
    awk -F',' '{
        printf " %-4d | %-15s | %-8d | %-10d | %-10s | %-10s \n-------------------------------------------------------------------------\n",++jumlah,$1,$2,$3,$4,$5
        if($5 == "Aktif")active++
        if($5 == "Menunggak")nunggak++
    }''END{
    printf("Total %d | Aktif: %d | Menunggak: %d\n",jumlah,active,nunggak)
    }' data/penghuni.csv
    read -p "[press] untuk melanjutkan"
    clear
    
}

editStatus(){
    echo "========================================================================="
    echo "                           EDIT STATUS"
    echo "========================================================================="
    read -rp "Masukan Nama Penghuni: " nama
    read -rp "Masukan  Status Baru (Aktif/Menunggak)" status
    
    awk  -F',' -v n="$nama" -v s="$status" 'BEGIN{OFS=","}''{
        if($1 == n){
        $5 = s}{print}
    }' data/penghuni.csv > data/penghuni.tmp && mv data/penghuni.tmp data/penghuni.csv
    echo "status \"$nama\" sudah diubah menjadi: $status"
    
    read -p "[press] untuk melanjutkan"
    clear
}

while true; do
    
    showMenu
    echo ""
    read -rp "Masukan kode perintah 1 - 6: " perintah
    case $perintah in
        1) addMember;;
        2)deleteMember;;
        3)
            clear
            showMember;;
        4)editStatus;;
        *)
            echo "Terimakasih telah menggunakan aplikasi"
            break
        ;;
    esac
done