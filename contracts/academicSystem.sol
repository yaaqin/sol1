// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SistemAkademik {
    struct Mahasiswa {
        string nama;
        uint256 nim;
        string jurusan;
        uint256[] nilai;
        bool isActive;
    }

    mapping(uint256 => Mahasiswa) public mahasiswa;
    mapping(address => bool) public authorized;
    uint256[] public daftarNIM;

    event MahasiswaEnrolled(uint256 nim, string nama);
    event NilaiAdded(uint256 nim, uint256 nilai);

    modifier onlyOwner() {
        require(authorized[msg.sender], "Tidak memiliki akses");
        _;
    }

    constructor() {
        authorized[msg.sender] = true;
    }

    // Enrollment mahasiswa baru
    function enrollMahasiswa(
        uint256 _nim,
        string memory _nama,
        string memory _jurusan
    ) public onlyOwner {
        Mahasiswa storage mhs = mahasiswa[_nim];
        require(mhs.nim == 0, "Mahasiswa sudah terdaftar");

        mhs.nim = _nim;
        mhs.nama = _nama;
        mhs.jurusan = _jurusan;
        mhs.isActive = false;

        daftarNIM.push(_nim);
        emit MahasiswaEnrolled(_nim, _nama);
    }

    // Menambahkan nilai mahasiswa
    function addNilai(uint256 _nim, uint256 _nilai) public onlyOwner {
        Mahasiswa storage mhs = mahasiswa[_nim];
        require(mhs.isActive, "Mahasiswa tidak aktif");

        mhs.nilai.push(_nilai);
        emit NilaiAdded(_nim, _nilai);
    }

    // Mengambil data akademik mahasiswa
    function getStudentInfo(uint256 _nim)
        public
        view
        returns (
            string memory,
            string memory,
            uint256[] memory,
            bool
        )
    {
        Mahasiswa storage mhs = mahasiswa[_nim];
        require(mhs.nim != 0, "Mahasiswa tidak ditemukan");
        return (mhs.nama, mhs.jurusan, mhs.nilai, mhs.isActive);
    }

    function deactivateStudent(uint256 _nim) public onlyOwner {
        Mahasiswa storage mhs = mahasiswa[_nim];
        require(mhs.nim != 0, "Mahasiswa tidak ditemukan");
        require(mhs.isActive == true, "Mahasiswa sudah di deactive");

        mhs.isActive = false;
    }

    function activateStudent(uint256 _nim) public onlyOwner {
        Mahasiswa storage mhs = mahasiswa[_nim];
        require(mhs.nim != 0, "Mahasiswa tidak ditemukan");
        require(mhs.isActive == false, "Mahasiswa sudah active");

        // if (mhs.nim != 0) {
        //     if (mhs.isActive == false) {
        //         mhs.isActive = true;
        //     }
        // }

        mhs.isActive = true;
    }
}
