// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract PemilihanBEM {
    struct Kandidat {
        string nama;
        string visi;
        uint256 suara;
    }
    
    Kandidat[] public kandidat;
    mapping(address => bool) public sudahMemilih;
    mapping(address => bool) public pemilihTerdaftar;
    
    uint256 public waktuMulai;
    uint256 public waktuSelesai;
    address public admin;
    
    event VoteCasted(address indexed voter, uint256 kandidatIndex);
    event KandidatAdded(string nama);
    event VotingStarted(uint256 waktuMulai, uint256 waktuSelesai);
    event VotingEnded(uint256 waktuSelesai);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Hanya admin yang bisa melakukan ini");
        _;
    }

    modifier onlyDuringVoting() {
        require(
            block.timestamp >= waktuMulai && 
            block.timestamp <= waktuSelesai, 
            "Voting belum dimulai atau sudah selesai"
        );
        _;
    }
    
    modifier onlyRegisteredVoter() {
        require(pemilihTerdaftar[msg.sender], "Anda belum terdaftar sebagai pemilih");
        _;
    }

    constructor(uint256 _waktuMulai, uint256 _waktuSelesai) {
        admin = msg.sender;
        waktuMulai = _waktuMulai;
        waktuSelesai = _waktuSelesai;
        emit VotingStarted(_waktuMulai, _waktuSelesai);
    }

    // Fungsi untuk menambah kandidat
    function addKandidat(string memory _nama, string memory _visi) public onlyAdmin {
        kandidat.push(Kandidat(_nama, _visi, 0));
        emit KandidatAdded(_nama);
    }

    // Fungsi untuk mendaftar pemilih
    function registerVoter(address _pemilih) public onlyAdmin {
        pemilihTerdaftar[_pemilih] = true;
    }

    // Fungsi untuk memilih kandidat
    function vote(uint256 _kandidatIndex) public onlyDuringVoting onlyRegisteredVoter {
        require(!sudahMemilih[msg.sender], "Anda sudah memilih");

        sudahMemilih[msg.sender] = true;
        kandidat[_kandidatIndex].suara += 1;

        emit VoteCasted(msg.sender, _kandidatIndex);
    }

    // Fungsi untuk melihat hasil sementara
    function getResults() public view returns (string memory namaKandidat, uint256 jumlahSuara) {
        uint256 maxSuara = 0;
        for (uint256 i = 0; i < kandidat.length; i++) {
            if (kandidat[i].suara > maxSuara) {
                maxSuara = kandidat[i].suara;
                namaKandidat = kandidat[i].nama;
                jumlahSuara = maxSuara;
            }
        }
    }

     function getKandidatList() public view returns (Kandidat[] memory) {
        return kandidat;
    }

    // Fungsi untuk mengakhiri voting
    function endVoting() public onlyAdmin {
        require(block.timestamp > waktuSelesai, "Voting belum selesai");
        emit VotingEnded(block.timestamp);
    }
}
