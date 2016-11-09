library IEEE;
use IEEE.numeric_std.all;

package tables is
	type uintArray is array(natural range<>) of unsigned(31 downto 0);
	type intArray2d is array(natural range<>, natural range<>) of integer;
	type uintArray2d is array(natural range<>, natural range<>) of unsigned(31 downto 0);
	constant phi : unsigned(31 downto 0) := X"9e3779b9";
	constant MARKER : integer := -1;
	constant SBox: intArray2d(0 to 31, 0 to 15) := 
    (( 3, 8,15, 1,10, 6, 5,11,14,13, 4, 2, 7, 0, 9,12 ),
	 (15,12, 2, 7, 9, 0, 5,10, 1,11,14, 8, 6,13, 3, 4 ),
	 ( 8, 6, 7, 9, 3,12,10,15,13, 1,14, 4, 0,11, 5, 2 ),
	 ( 0,15,11, 8,12, 9, 6, 3,13, 1, 2, 4,10, 7, 5,14 ),
	 ( 1,15, 8, 3,12, 0,11, 6, 2, 5, 4,10, 9,14, 7,13 ),
	 (15, 5, 2,11, 4,10, 9,12, 0, 3,14, 8,13, 6, 7, 1 ),
	 ( 7, 2,12, 5, 8, 4, 6,11,14, 9, 1,15,13, 3,10, 0 ),
	 ( 1,13,15, 0,14, 8, 2,11, 7, 4,12,10, 9, 3, 5, 6 ),
	 ( 3, 8,15, 1,10, 6, 5,11,14,13, 4, 2, 7, 0, 9,12 ),
	 (15,12, 2, 7, 9, 0, 5,10, 1,11,14, 8, 6,13, 3, 4 ),
	 ( 8, 6, 7, 9, 3,12,10,15,13, 1,14, 4, 0,11, 5, 2 ),
	 ( 0,15,11, 8,12, 9, 6, 3,13, 1, 2, 4,10, 7, 5,14 ),
	 ( 1,15, 8, 3,12, 0,11, 6, 2, 5, 4,10, 9,14, 7,13 ),
	 (15, 5, 2,11, 4,10, 9,12, 0, 3,14, 8,13, 6, 7, 1 ),
	 ( 7, 2,12, 5, 8, 4, 6,11,14, 9, 1,15,13, 3,10, 0 ),
	 ( 1,13,15, 0,14, 8, 2,11, 7, 4,12,10, 9, 3, 5, 6 ),
	 ( 3, 8,15, 1,10, 6, 5,11,14,13, 4, 2, 7, 0, 9,12 ),
	 (15,12, 2, 7, 9, 0, 5,10, 1,11,14, 8, 6,13, 3, 4 ),
	 ( 8, 6, 7, 9, 3,12,10,15,13, 1,14, 4, 0,11, 5, 2 ),
	 ( 0,15,11, 8,12, 9, 6, 3,13, 1, 2, 4,10, 7, 5,14 ),
	 ( 1,15, 8, 3,12, 0,11, 6, 2, 5, 4,10, 9,14, 7,13 ),
	 (15, 5, 2,11, 4,10, 9,12, 0, 3,14, 8,13, 6, 7, 1 ),
	 ( 7, 2,12, 5, 8, 4, 6,11,14, 9, 1,15,13, 3,10, 0 ),
	 ( 1,13,15, 0,14, 8, 2,11, 7, 4,12,10, 9, 3, 5, 6 ),
	 ( 3, 8,15, 1,10, 6, 5,11,14,13, 4, 2, 7, 0, 9,12 ),
	 (15,12, 2, 7, 9, 0, 5,10, 1,11,14, 8, 6,13, 3, 4 ),
	 ( 8, 6, 7, 9, 3,12,10,15,13, 1,14, 4, 0,11, 5, 2 ),
	 ( 0,15,11, 8,12, 9, 6, 3,13, 1, 2, 4,10, 7, 5,14 ),
	 ( 1,15, 8, 3,12, 0,11, 6, 2, 5, 4,10, 9,14, 7,13 ),
	 (15, 5, 2,11, 4,10, 9,12, 0, 3,14, 8,13, 6, 7, 1 ),
	 ( 7, 2,12, 5, 8, 4, 6,11,14, 9, 1,15,13, 3,10, 0 ),
	 ( 1,13,15, 0,14, 8, 2,11, 7, 4,12,10, 9, 3, 5, 6 ));
	 
	 constant SBoxInverse: intArray2d(0 to 31, 0 to 15) := (
    (13, 3,11, 0,10, 6, 5,12, 1,14, 4, 7,15, 9, 8, 2 ),
    ( 5, 8, 2,14,15, 6,12, 3,11, 4, 7, 9, 1,13,10, 0 ),
    (12, 9,15, 4,11,14, 1, 2, 0, 3, 6,13, 5, 8,10, 7 ),
    ( 0, 9,10, 7,11,14, 6,13, 3, 5,12, 2, 4, 8,15, 1 ),
    ( 5, 0, 8, 3,10, 9, 7,14, 2,12,11, 6, 4,15,13, 1 ),
    ( 8,15, 2, 9, 4, 1,13,14,11, 6, 5, 3, 7,12,10, 0 ),
    (15,10, 1,13, 5, 3, 6, 0, 4, 9,14, 7, 2,12, 8,11 ),
    ( 3, 0, 6,13, 9,14,15, 8, 5,12,11, 7,10, 1, 4, 2 ),
    (13, 3,11, 0,10, 6, 5,12, 1,14, 4, 7,15, 9, 8, 2 ),
    ( 5, 8, 2,14,15, 6,12, 3,11, 4, 7, 9, 1,13,10, 0 ),
    (12, 9,15, 4,11,14, 1, 2, 0, 3, 6,13, 5, 8,10, 7 ),
    ( 0, 9,10, 7,11,14, 6,13, 3, 5,12, 2, 4, 8,15, 1 ),
    ( 5, 0, 8, 3,10, 9, 7,14, 2,12,11, 6, 4,15,13, 1 ),
    ( 8,15, 2, 9, 4, 1,13,14,11, 6, 5, 3, 7,12,10, 0 ),
    (15,10, 1,13, 5, 3, 6, 0, 4, 9,14, 7, 2,12, 8,11 ),
    ( 3, 0, 6,13, 9,14,15, 8, 5,12,11, 7,10, 1, 4, 2 ),
    (13, 3,11, 0,10, 6, 5,12, 1,14, 4, 7,15, 9, 8, 2 ),
    ( 5, 8, 2,14,15, 6,12, 3,11, 4, 7, 9, 1,13,10, 0 ),
    (12, 9,15, 4,11,14, 1, 2, 0, 3, 6,13, 5, 8,10, 7 ),
    ( 0, 9,10, 7,11,14, 6,13, 3, 5,12, 2, 4, 8,15, 1 ),
    ( 5, 0, 8, 3,10, 9, 7,14, 2,12,11, 6, 4,15,13, 1 ),
    ( 8,15, 2, 9, 4, 1,13,14,11, 6, 5, 3, 7,12,10, 0 ),
    (15,10, 1,13, 5, 3, 6, 0, 4, 9,14, 7, 2,12, 8,11 ),
    ( 3, 0, 6,13, 9,14,15, 8, 5,12,11, 7,10, 1, 4, 2 ),
    (13, 3,11, 0,10, 6, 5,12, 1,14, 4, 7,15, 9, 8, 2 ),
    ( 5, 8, 2,14,15, 6,12, 3,11, 4, 7, 9, 1,13,10, 0 ),
    (12, 9,15, 4,11,14, 1, 2, 0, 3, 6,13, 5, 8,10, 7 ),
    ( 0, 9,10, 7,11,14, 6,13, 3, 5,12, 2, 4, 8,15, 1 ),
    ( 5, 0, 8, 3,10, 9, 7,14, 2,12,11, 6, 4,15,13, 1 ),
    ( 8,15, 2, 9, 4, 1,13,14,11, 6, 5, 3, 7,12,10, 0 ),
    (15,10, 1,13, 5, 3, 6, 0, 4, 9,14, 7, 2,12, 8,11 ),
    ( 3, 0, 6,13, 9,14,15, 8, 5,12,11, 7,10, 1, 4, 2 )
	);
	 
	constant LTTableInverse: intArray2d(0 to 127, 0 to 7) := (
    (53, 55, 72, MARKER, others => 0 ),
    (1, 5, 20, 90, MARKER, others => 0 ),
    (15, 102, MARKER, others => 0 ),
    (3, 31, 90, MARKER, others => 0 ),
    (57, 59, 76, MARKER, others => 0 ),
    (5, 9, 24, 94, MARKER, others => 0 ),
    (19, 106, MARKER, others => 0 ),
    (7, 35, 94, MARKER, others => 0 ),
    (61, 63, 80, MARKER, others => 0 ),
    (9, 13, 28, 98, MARKER, others => 0 ),
    (23, 110, MARKER, others => 0 ),
    (11, 39, 98, MARKER, others => 0 ),
    (65, 67, 84, MARKER, others => 0 ),
    (13, 17, 32, 102, MARKER, others => 0 ),
    (27, 114, MARKER, others => 0 ),
    (1, 3, 15, 20, 43, 102, MARKER, others => 0 ),
    (69, 71, 88, MARKER, others => 0 ),
    (17, 21, 36, 106, MARKER, others => 0 ),
    (1, 31, 118, MARKER, others => 0 ),
    (5, 7, 19, 24, 47, 106, MARKER, others => 0 ),
    (73, 75, 92, MARKER, others => 0 ),
    (21, 25, 40, 110, MARKER, others => 0 ),
    (5, 35, 122, MARKER, others => 0 ),
    (9, 11, 23, 28, 51, 110, MARKER, others => 0 ),
    (77, 79, 96, MARKER, others => 0 ),
    (25, 29, 44, 114, MARKER, others => 0 ),
    (9, 39, 126, MARKER, others => 0 ),
    (13, 15, 27, 32, 55, 114, MARKER, others => 0 ),
    (81, 83, 100, MARKER, others => 0 ),
    (1, 29, 33, 48, 118, MARKER, others => 0 ),
    (2, 13, 43, MARKER, others => 0 ),
    (1, 17, 19, 31, 36, 59, 118, MARKER, others => 0 ),
    (85, 87, 104, MARKER, others => 0 ),
    (5, 33, 37, 52, 122, MARKER, others => 0 ),
    (6, 17, 47, MARKER, others => 0 ),
    (5, 21, 23, 35, 40, 63, 122, MARKER, others => 0 ),
    (89, 91, 108, MARKER, others => 0 ),
    (9, 37, 41, 56, 126, MARKER, others => 0 ),
    (10, 21, 51, MARKER, others => 0 ),
    (9, 25, 27, 39, 44, 67, 126, MARKER, others => 0 ),
    (93, 95, 112, MARKER, others => 0 ),
    (2, 13, 41, 45, 60, MARKER, others => 0 ),
    (14, 25, 55, MARKER, others => 0 ),
    (2, 13, 29, 31, 43, 48, 71, MARKER, others => 0 ),
    (97, 99, 116, MARKER, others => 0 ),
    (6, 17, 45, 49, 64, MARKER, others => 0 ),
    (18, 29, 59, MARKER, others => 0 ),
    (6, 17, 33, 35, 47, 52, 75, MARKER, others => 0 ),
    (101, 103, 120, MARKER, others => 0 ),
    (10, 21, 49, 53, 68, MARKER, others => 0 ),
    (22, 33, 63, MARKER, others => 0 ),
    (10, 21, 37, 39, 51, 56, 79, MARKER, others => 0 ),
    (105, 107, 124, MARKER, others => 0 ),
    (14, 25, 53, 57, 72, MARKER, others => 0 ),
    (26, 37, 67, MARKER, others => 0 ),
    (14, 25, 41, 43, 55, 60, 83, MARKER, others => 0 ),
    (0, 109, 111, MARKER, others => 0 ),
    (18, 29, 57, 61, 76, MARKER, others => 0 ),
    (30, 41, 71, MARKER, others => 0 ),
    (18, 29, 45, 47, 59, 64, 87, MARKER, others => 0 ),
    (4, 113, 115, MARKER, others => 0 ),
    (22, 33, 61, 65, 80, MARKER, others => 0 ),
    (34, 45, 75, MARKER, others => 0 ),
    (22, 33, 49, 51, 63, 68, 91, MARKER, others => 0 ),
    (8, 117, 119, MARKER, others => 0 ),
    (26, 37, 65, 69, 84, MARKER, others => 0 ),
    (38, 49, 79, MARKER, others => 0 ),
    (26, 37, 53, 55, 67, 72, 95, MARKER, others => 0 ),
    (12, 121, 123, MARKER, others => 0 ),
    (30, 41, 69, 73, 88, MARKER, others => 0 ),
    (42, 53, 83, MARKER, others => 0 ),
    (30, 41, 57, 59, 71, 76, 99, MARKER, others => 0 ),
    (16, 125, 127, MARKER, others => 0 ),
    (34, 45, 73, 77, 92, MARKER, others => 0 ),
    (46, 57, 87, MARKER, others => 0 ),
    (34, 45, 61, 63, 75, 80, 103, MARKER, others => 0 ),
    (1, 3, 20, MARKER, others => 0 ),
    (38, 49, 77, 81, 96, MARKER, others => 0 ),
    (50, 61, 91, MARKER, others => 0 ),
    (38, 49, 65, 67, 79, 84, 107, MARKER, others => 0 ),
    (5, 7, 24, MARKER, others => 0 ),
    (42, 53, 81, 85, 100, MARKER, others => 0 ),
    (54, 65, 95, MARKER, others => 0 ),
    (42, 53, 69, 71, 83, 88, 111, MARKER, others => 0 ),
    (9, 11, 28, MARKER, others => 0 ),
    (46, 57, 85, 89, 104, MARKER, others => 0 ),
    (58, 69, 99, MARKER, others => 0 ),
    (46, 57, 73, 75, 87, 92, 115, MARKER, others => 0 ),
    (13, 15, 32, MARKER, others => 0 ),
    (50, 61, 89, 93, 108, MARKER, others => 0 ),
    (62, 73, 103, MARKER, others => 0 ),
    (50, 61, 77, 79, 91, 96, 119, MARKER, others => 0 ),
    (17, 19, 36, MARKER, others => 0 ),
    (54, 65, 93, 97, 112, MARKER, others => 0 ),
    (66, 77, 107, MARKER, others => 0 ),
    (54, 65, 81, 83, 95, 100, 123, MARKER, others => 0 ),
    (21, 23, 40, MARKER, others => 0 ),
    (58, 69, 97, 101, 116, MARKER, others => 0 ),
    (70, 81, 111, MARKER, others => 0 ),
    (58, 69, 85, 87, 99, 104, 127, MARKER, others => 0 ),
    (25, 27, 44, MARKER, others => 0 ),
    (62, 73, 101, 105, 120, MARKER, others => 0 ),
    (74, 85, 115, MARKER, others => 0 ),
    (3, 62, 73, 89, 91, 103, 108, MARKER, others => 0 ),
    (29, 31, 48, MARKER, others => 0 ),
    (66, 77, 105, 109, 124, MARKER, others => 0 ),
    (78, 89, 119, MARKER, others => 0 ),
    (7, 66, 77, 93, 95, 107, 112, MARKER, others => 0 ),
    (33, 35, 52, MARKER, others => 0 ),
    (0, 70, 81, 109, 113, MARKER, others => 0 ),
    (82, 93, 123, MARKER, others => 0 ),
    (11, 70, 81, 97, 99, 111, 116, MARKER, others => 0 ),
    (37, 39, 56, MARKER, others => 0 ),
    (4, 74, 85, 113, 117, MARKER, others => 0 ),
    (86, 97, 127, MARKER, others => 0 ),
    (15, 74, 85, 101, 103, 115, 120, MARKER, others => 0 ),
    (41, 43, 60, MARKER, others => 0 ),
    (8, 78, 89, 117, 121, MARKER, others => 0 ),
    (3, 90, MARKER, others => 0 ),
    (19, 78, 89, 105, 107, 119, 124, MARKER, others => 0 ),
    (45, 47, 64, MARKER, others => 0 ),
    (12, 82, 93, 121, 125, MARKER, others => 0 ),
    (7, 94, MARKER, others => 0 ),
    (0, 23, 82, 93, 109, 111, 123, MARKER, others => 0 ),
    (49, 51, 68, MARKER, others => 0 ),
    (1, 16, 86, 97, 125, MARKER, others => 0 ),
    (11, 98, MARKER, others => 0 ),
    (4, 27, 86, 97, 113, 115, 127, MARKER, others => 0 )
);

	constant LTTable: intArray2d(0 to 127, 0 to 7) := (
    (16, 52, 56, 70, 83, 94, 105, MARKER, others => 0 ),
    (72, 114, 125, MARKER, others => 0 ),
    (2, 9, 15, 30, 76, 84, 126, MARKER, others => 0 ),
    (36, 90, 103, MARKER, others => 0 ),
    (20, 56, 60, 74, 87, 98, 109, MARKER, others => 0 ),
    (1, 76, 118, MARKER, others => 0 ),
    (2, 6, 13, 19, 34, 80, 88, MARKER, others => 0 ),
    (40, 94, 107, MARKER, others => 0 ),
    (24, 60, 64, 78, 91, 102, 113, MARKER, others => 0 ),
    (5, 80, 122, MARKER, others => 0 ),
    (6, 10, 17, 23, 38, 84, 92, MARKER, others => 0 ),
    (44, 98, 111, MARKER, others => 0 ),
    (28, 64, 68, 82, 95, 106, 117, MARKER, others => 0 ),
    (9, 84, 126, MARKER, others => 0 ),
    (10, 14, 21, 27, 42, 88, 96, MARKER, others => 0 ),
    (48, 102, 115, MARKER, others => 0 ),
    (32, 68, 72, 86, 99, 110, 121, MARKER, others => 0 ),
    (2, 13, 88, MARKER, others => 0 ),
    (14, 18, 25, 31, 46, 92, 100, MARKER, others => 0 ),
    (52, 106, 119, MARKER, others => 0 ),
    (36, 72, 76, 90, 103, 114, 125, MARKER, others => 0 ),
    (6, 17, 92, MARKER, others => 0 ),
    (18, 22, 29, 35, 50, 96, 104, MARKER, others => 0 ),
    (56, 110, 123, MARKER, others => 0 ),
    (1, 40, 76, 80, 94, 107, 118, MARKER, others => 0 ),
    (10, 21, 96, MARKER, others => 0 ),
    (22, 26, 33, 39, 54, 100, 108, MARKER, others => 0 ),
    (60, 114, 127, MARKER, others => 0 ),
    (5, 44, 80, 84, 98, 111, 122, MARKER, others => 0 ),
    (14, 25, 100, MARKER, others => 0 ),
    (26, 30, 37, 43, 58, 104, 112, MARKER, others => 0 ),
    (3, 118, MARKER, others => 0 ),
    (9, 48, 84, 88, 102, 115, 126, MARKER, others => 0 ),
    (18, 29, 104, MARKER, others => 0 ),
    (30, 34, 41, 47, 62, 108, 116, MARKER, others => 0 ),
    (7, 122, MARKER, others => 0 ),
    (2, 13, 52, 88, 92, 106, 119, MARKER, others => 0 ),
    (22, 33, 108, MARKER, others => 0 ),
    (34, 38, 45, 51, 66, 112, 120, MARKER, others => 0 ),
    (11, 126, MARKER, others => 0 ),
    (6, 17, 56, 92, 96, 110, 123, MARKER, others => 0 ),
    (26, 37, 112, MARKER, others => 0 ),
    (38, 42, 49, 55, 70, 116, 124, MARKER, others => 0 ),
    (2, 15, 76, MARKER, others => 0 ),
    (10, 21, 60, 96, 100, 114, 127, MARKER, others => 0 ),
    (30, 41, 116, MARKER, others => 0 ),
    (0, 42, 46, 53, 59, 74, 120, MARKER, others => 0 ),
    (6, 19, 80, MARKER, others => 0 ),
    (3, 14, 25, 100, 104, 118, MARKER, others => 0 ),
    (34, 45, 120, MARKER, others => 0 ),
    (4, 46, 50, 57, 63, 78, 124, MARKER, others => 0 ),
    (10, 23, 84, MARKER, others => 0 ),
    (7, 18, 29, 104, 108, 122, MARKER, others => 0 ),
    (38, 49, 124, MARKER, others => 0 ),
    (0, 8, 50, 54, 61, 67, 82, MARKER, others => 0 ),
    (14, 27, 88, MARKER, others => 0 ),
    (11, 22, 33, 108, 112, 126, MARKER, others => 0 ),
    (0, 42, 53, MARKER, others => 0 ),
    (4, 12, 54, 58, 65, 71, 86, MARKER, others => 0 ),
    (18, 31, 92, MARKER, others => 0 ),
    (2, 15, 26, 37, 76, 112, 116, MARKER, others => 0 ),
    (4, 46, 57, MARKER, others => 0 ),
    (8, 16, 58, 62, 69, 75, 90, MARKER, others => 0 ),
    (22, 35, 96, MARKER, others => 0 ),
    (6, 19, 30, 41, 80, 116, 120, MARKER, others => 0 ),
    (8, 50, 61, MARKER, others => 0 ),
    (12, 20, 62, 66, 73, 79, 94, MARKER, others => 0 ),
    (26, 39, 100, MARKER, others => 0 ),
    (10, 23, 34, 45, 84, 120, 124, MARKER, others => 0 ),
    (12, 54, 65, MARKER, others => 0 ),
    (16, 24, 66, 70, 77, 83, 98, MARKER, others => 0 ),
    (30, 43, 104, MARKER, others => 0 ),
    (0, 14, 27, 38, 49, 88, 124, MARKER, others => 0 ),
    (16, 58, 69, MARKER, others => 0 ),
    (20, 28, 70, 74, 81, 87, 102, MARKER, others => 0 ),
    (34, 47, 108, MARKER, others => 0 ),
    (0, 4, 18, 31, 42, 53, 92, MARKER, others => 0 ),
    (20, 62, 73, MARKER, others => 0 ),
    (24, 32, 74, 78, 85, 91, 106, MARKER, others => 0 ),
    (38, 51, 112, MARKER, others => 0 ),
    (4, 8, 22, 35, 46, 57, 96, MARKER, others => 0 ),
    (24, 66, 77, MARKER, others => 0 ),
    (28, 36, 78, 82, 89, 95, 110, MARKER, others => 0 ),
    (42, 55, 116, MARKER, others => 0 ),
    (8, 12, 26, 39, 50, 61, 100, MARKER, others => 0 ),
    (28, 70, 81, MARKER, others => 0 ),
    (32, 40, 82, 86, 93, 99, 114, MARKER, others => 0 ),
    (46, 59, 120, MARKER, others => 0 ),
    (12, 16, 30, 43, 54, 65, 104, MARKER, others => 0 ),
    (32, 74, 85, MARKER, others => 0 ),
    (36, 90, 103, 118, MARKER, others => 0 ),
    (50, 63, 124, MARKER, others => 0 ),
    (16, 20, 34, 47, 58, 69, 108, MARKER, others => 0 ),
    (36, 78, 89, MARKER, others => 0 ),
    (40, 94, 107, 122, MARKER, others => 0 ),
    (0, 54, 67, MARKER, others => 0 ),
    (20, 24, 38, 51, 62, 73, 112, MARKER, others => 0 ),
    (40, 82, 93, MARKER, others => 0 ),
    (44, 98, 111, 126, MARKER, others => 0 ),
    (4, 58, 71, MARKER, others => 0 ),
    (24, 28, 42, 55, 66, 77, 116, MARKER, others => 0 ),
    (44, 86, 97, MARKER, others => 0 ),
    (2, 48, 102, 115, MARKER, others => 0 ),
    (8, 62, 75, MARKER, others => 0 ),
    (28, 32, 46, 59, 70, 81, 120, MARKER, others => 0 ),
    (48, 90, 101, MARKER, others => 0 ),
    (6, 52, 106, 119, MARKER, others => 0 ),
    (12, 66, 79, MARKER, others => 0 ),
    (32, 36, 50, 63, 74, 85, 124, MARKER, others => 0 ),
    (52, 94, 105, MARKER, others => 0 ),
    (10, 56, 110, 123, MARKER, others => 0 ),
    (16, 70, 83, MARKER, others => 0 ),
    (0, 36, 40, 54, 67, 78, 89, MARKER, others => 0 ),
    (56, 98, 109, MARKER, others => 0 ),
    (14, 60, 114, 127, MARKER, others => 0 ),
    (20, 74, 87, MARKER, others => 0 ),
    (4, 40, 44, 58, 71, 82, 93, MARKER, others => 0 ),
    (60, 102, 113, MARKER, others => 0 ),
    (3, 18, 72, 114, 118, 125, MARKER, others => 0 ),
    (24, 78, 91, MARKER, others => 0 ),
    (8, 44, 48, 62, 75, 86, 97, MARKER, others => 0 ),
    (64, 106, 117, MARKER, others => 0 ),
    (1, 7, 22, 76, 118, 122, MARKER, others => 0 ),
    (28, 82, 95, MARKER, others => 0 ),
    (12, 48, 52, 66, 79, 90, 101, MARKER, others => 0 ),
    (68, 110, 121, MARKER, others => 0 ),
    (5, 11, 26, 80, 122, 126, MARKER, others => 0 ),
    (32, 86, 99, MARKER, others => 0 )
);
end package tables;