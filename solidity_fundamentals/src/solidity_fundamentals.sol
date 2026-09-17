// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;


// =============================================================
// BASIC INHERITANCE
// =============================================================

contract Parent {
    function externalFunction() public pure returns (string memory) {
        return "Hello, from parent!";
    }
}

contract Aunt {
    function sayHello() public pure returns (string memory) {
        return "Hello, from Aunt!";
    }
}

contract Child is Parent {
    function sayHelloFromChild() public pure returns (string memory) {
        return "Hello, from child!";
    }
}


// =============================================================
// CONTRACT-TO-CONTRACT INTERACTION
// =============================================================

contract Parent_f {
    function parentFunction() public pure returns (string memory) {
        return "Called from another contract";
    }
}

contract Child_f {
    Parent_f public immutable externalContract;

    constructor(address _externalContractAddress) {
        require(
            _externalContractAddress != address(0),
            "Invalid contract address"
        );

        require(
            _externalContractAddress.code.length > 0,
            "Address is not a contract"
        );

        externalContract = Parent_f(_externalContractAddress);
    }

    function callExternalFunction()
        public
        view
        returns (string memory)
    {
        return externalContract.parentFunction();
    }
}


// =============================================================
// ADMIN CONTROL
// =============================================================

contract AdminControl {
    address public admin;

    event AdminChanged(
        address indexed previousAdmin,
        address indexed newAdmin
    );

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function changeAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid admin address");

        address previousAdmin = admin;
        admin = _newAdmin;

        emit AdminChanged(previousAdmin, _newAdmin);
    }
}


// =============================================================
// SCHOOL SYSTEM
// =============================================================

contract School {
    string public schoolName;

    constructor(string memory _name) {
        require(bytes(_name).length > 0, "School name required");
        schoolName = _name;
    }

    function getSchoolName() public view returns (string memory) {
        return schoolName;
    }
}


contract StudentSystem is School, AdminControl {
    struct Student {
        string name;
        uint256 mathScore;
        uint256 scienceScore;
        bool exists;
    }

    mapping(uint256 => Student) private students;

    event StudentAdded(
        uint256 indexed id,
        string name,
        uint256 mathScore,
        uint256 scienceScore
    );

    constructor(string memory _schoolName)
        School(_schoolName)
    {}

    function addStudent(
        uint256 _id,
        string calldata _name,
        uint256 _mathGrade,
        uint256 _scienceGrade
    )
        public
        onlyAdmin
    {
        require(!students[_id].exists, "Student already exists");
        require(bytes(_name).length > 0, "Student name required");
        require(_mathGrade <= 100, "Invalid math grade");
        require(_scienceGrade <= 100, "Invalid science grade");

        students[_id] = Student({
            name: _name,
            mathScore: _mathGrade,
            scienceScore: _scienceGrade,
            exists: true
        });

        emit StudentAdded(
            _id,
            _name,
            _mathGrade,
            _scienceGrade
        );
    }

    function getStudent(uint256 _id)
        public
        view
        returns (
            string memory name,
            uint256 mathScore,
            uint256 scienceScore
        )
    {
        require(students[_id].exists, "Student does not exist");

        Student storage student = students[_id];

        return (
            student.name,
            student.mathScore,
            student.scienceScore
        );
    }

    function studentExists(uint256 _id)
        public
        view
        returns (bool)
    {
        return students[_id].exists;
    }
}


// =============================================================
// WTC
// =============================================================

contract WTC is AdminControl {
    struct Student {
        string name;
        uint256 formativeScore;
        uint256 summativeScore;
        bool exists;
    }

    string public schoolName;

    mapping(uint256 => Student) private students;

    event StudentAdded(
        uint256 indexed id,
        string name,
        uint256 formativeScore,
        uint256 summativeScore
    );

    constructor(string memory _name) {
        require(bytes(_name).length > 0, "Institution name required");
        schoolName = _name;
    }

    function getInstitutionName()
        public
        view
        returns (string memory)
    {
        return schoolName;
    }

    function addStudent(
        uint256 _id,
        string calldata _name,
        uint256 _formativeScore,
        uint256 _summativeScore
    )
        public
        onlyAdmin
    {
        require(!students[_id].exists, "Student already exists");
        require(bytes(_name).length > 0, "Student name required");
        require(_formativeScore <= 100, "Invalid formative score");
        require(_summativeScore <= 100, "Invalid summative score");

        students[_id] = Student({
            name: _name,
            formativeScore: _formativeScore,
            summativeScore: _summativeScore,
            exists: true
        });

        emit StudentAdded(
            _id,
            _name,
            _formativeScore,
            _summativeScore
        );
    }

    function getStudent(uint256 _id)
        public
        view
        returns (
            string memory name,
            uint256 formativeScore,
            uint256 summativeScore
        )
    {
        require(students[_id].exists, "Student does not exist");

        Student storage student = students[_id];

        return (
            student.name,
            student.formativeScore,
            student.summativeScore
        );
    }

    function studentExists(uint256 _id)
        public
        view
        returns (bool)
    {
        return students[_id].exists;
    }
}


// =============================================================
// ABC
// =============================================================

contract ABC is AdminControl {
    struct Member {
        string name;
        string academicLevel;
        bool exists;
    }

    string public instituteName;

    mapping(uint256 => Member) private members;

    event MemberAdded(
        uint256 indexed id,
        string name,
        string academicLevel
    );

    constructor(string memory _name) {
        require(bytes(_name).length > 0, "Institute name required");
        instituteName = _name;
    }

    function getInstituteName()
        public
        view
        returns (string memory)
    {
        return instituteName;
    }

    function addMember(
        uint256 _id,
        string calldata _name,
        string calldata _academicLevel
    )
        public
        onlyAdmin
    {
        require(!members[_id].exists, "Member already exists");
        require(bytes(_name).length > 0, "Member name required");
        require(_isValidLevel(_academicLevel), "Invalid academic level");

        members[_id] = Member({
            name: _name,
            academicLevel: _academicLevel,
            exists: true
        });

        emit MemberAdded(
            _id,
            _name,
            _academicLevel
        );
    }

    function getMember(uint256 _id)
        public
        view
        returns (
            string memory name,
            string memory academicLevel
        )
    {
        require(members[_id].exists, "Member does not exist");

        Member storage member = members[_id];

        return (
            member.name,
            member.academicLevel
        );
    }

    function memberExists(uint256 _id)
        public
        view
        returns (bool)
    {
        return members[_id].exists;
    }

    function _isValidLevel(string memory _level)
        internal
        pure
        returns (bool)
    {
        bytes32 levelHash = keccak256(bytes(_level));

        return (
            levelHash == keccak256(bytes("beginner")) ||
            levelHash == keccak256(bytes("junior")) ||
            levelHash == keccak256(bytes("senior"))
        );
    }
}


// =============================================================
// WTC + ABC LINK
// =============================================================

contract WTCABCLink {
    WTC public immutable wtc;
    ABC public immutable abc;

    constructor(
        address _wtcAddress,
        address _abcAddress
    ) {
        require(_wtcAddress != address(0), "Invalid WTC address");
        require(_abcAddress != address(0), "Invalid ABC address");

        require(
            _wtcAddress.code.length > 0,
            "WTC address is not a contract"
        );

        require(
            _abcAddress.code.length > 0,
            "ABC address is not a contract"
        );

        wtc = WTC(_wtcAddress);
        abc = ABC(_abcAddress);
    }

    function getCombinedStudentProfile(uint256 _id)
        public
        view
        returns (
            string memory wtcName,
            uint256 formativeScore,
            uint256 summativeScore,
            string memory abcName,
            string memory academicLevel
        )
    {
        require(
            wtc.studentExists(_id),
            "WTC student does not exist"
        );

        require(
            abc.memberExists(_id),
            "ABC member does not exist"
        );

        (
            string memory _wtcName,
            uint256 _formativeScore,
            uint256 _summativeScore
        ) = wtc.getStudent(_id);

        (
            string memory _abcName,
            string memory _academicLevel
        ) = abc.getMember(_id);

        return (
            _wtcName,
            _formativeScore,
            _summativeScore,
            _abcName,
            _academicLevel
        );
    }
}