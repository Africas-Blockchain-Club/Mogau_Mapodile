// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "../src/solidity_fundamentals.sol";

contract SolidityFundamentalsTest is Test {
    StudentSystem studentSystem;
    WTC wtc;
    ABC abc;
    WTCABCLink link;

    address nonAdmin = address(0xBEEF);

    function setUp() public {
        studentSystem = new StudentSystem("Test School");

        wtc = new WTC("WeThinkCode");
        abc = new ABC("Africa Blockchain Club");

        link = new WTCABCLink(
            address(wtc),
            address(abc)
        );
    }

    // ---------------------------------------------------------
    // INHERITANCE
    // ---------------------------------------------------------

    function testChildInheritsParentFunction() public {
        Child child = new Child();

        assertEq(
            child.externalFunction(),
            "Hello, from parent!"
        );
    }

    // ---------------------------------------------------------
    // CONTRACT INTERACTION
    // ---------------------------------------------------------

    function testExternalContractInteraction() public {
        Parent_f parent = new Parent_f();
        Child_f child = new Child_f(address(parent));

        assertEq(
            child.callExternalFunction(),
            "Called from another contract"
        );
    }

    function testRejectsInvalidExternalContractAddress() public {
        vm.expectRevert("Invalid contract address");

        new Child_f(address(0));
    }

    // ---------------------------------------------------------
    // STUDENT SYSTEM
    // ---------------------------------------------------------

    function testAdminCanAddStudent() public {
        studentSystem.addStudent(
            1,
            "Mosa",
            75,
            82
        );

        (
            string memory name,
            uint256 mathScore,
            uint256 scienceScore
        ) = studentSystem.getStudent(1);

        assertEq(name, "Mosa");
        assertEq(mathScore, 75);
        assertEq(scienceScore, 82);
    }

    function testNonAdminCannotAddStudent() public {
        vm.prank(nonAdmin);

        vm.expectRevert("Not admin");

        studentSystem.addStudent(
            1,
            "Mosa",
            75,
            82
        );
    }

    function testCannotAddDuplicateStudent() public {
        studentSystem.addStudent(
            1,
            "Mosa",
            75,
            82
        );

        vm.expectRevert("Student already exists");

        studentSystem.addStudent(
            1,
            "Another Student",
            90,
            90
        );
    }

    function testRejectsMathGradeAbove100() public {
        vm.expectRevert("Invalid math grade");

        studentSystem.addStudent(
            1,
            "Mosa",
            101,
            80
        );
    }

    function testRejectsScienceGradeAbove100() public {
        vm.expectRevert("Invalid science grade");

        studentSystem.addStudent(
            1,
            "Mosa",
            80,
            101
        );
    }

    function testCannotRetrieveMissingStudent() public {
        vm.expectRevert("Student does not exist");

        studentSystem.getStudent(999);
    }

    // ---------------------------------------------------------
    // ADMIN
    // ---------------------------------------------------------

    function testAdminCanChangeAdmin() public {
        address newAdmin = address(0x1234);

        studentSystem.changeAdmin(newAdmin);

        assertEq(
            studentSystem.admin(),
            newAdmin
        );
    }

    function testCannotSetAdminToZeroAddress() public {
        vm.expectRevert("Invalid admin address");

        studentSystem.changeAdmin(address(0));
    }

    // ---------------------------------------------------------
    // WTC
    // ---------------------------------------------------------

    function testAddWTCStudent() public {
        wtc.addStudent(
            1,
            "Mosa",
            82,
            87
        );

        (
            string memory name,
            uint256 formative,
            uint256 summative
        ) = wtc.getStudent(1);

        assertEq(name, "Mosa");
        assertEq(formative, 82);
        assertEq(summative, 87);
    }

    // ---------------------------------------------------------
    // ABC
    // ---------------------------------------------------------

    function testAddABCMember() public {
        abc.addMember(
            1,
            "Mosa",
            "beginner"
        );

        (
            string memory name,
            string memory level
        ) = abc.getMember(1);

        assertEq(name, "Mosa");
        assertEq(level, "beginner");
    }

    function testRejectInvalidABCLevel() public {
        vm.expectRevert("Invalid academic level");

        abc.addMember(
            1,
            "Mosa",
            "expert"
        );
    }

    // ---------------------------------------------------------
    // WTC + ABC
    // ---------------------------------------------------------

    function testCombinedStudentProfile() public {
        wtc.addStudent(
            1,
            "Mosa",
            82,
            87
        );

        abc.addMember(
            1,
            "Mosa",
            "beginner"
        );

        (
            string memory wtcName,
            uint256 formative,
            uint256 summative,
            string memory abcName,
            string memory level
        ) = link.getCombinedStudentProfile(1);

        assertEq(wtcName, "Mosa");
        assertEq(formative, 82);
        assertEq(summative, 87);

        assertEq(abcName, "Mosa");
        assertEq(level, "beginner");
    }
}