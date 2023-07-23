-- Ex1 Q1
SELECT PS.NAME_OF_SCHOOL, PS.COMMUNITY_AREA_NAME, 
PS.AVERAGE_TEACHER_ATTENDANCE, PS.AVERAGE_STUDENT_ATTENDANCE  
FROM CHICAGO_PUBLIC_SCHOOLS PS LEFT OUTER JOIN CENSUS_DATA CE
ON PS.COMMUNITY_AREA_NUMBER = CE.COMMUNITY_AREA_NUMBER
WHERE CE.HARDSHIP_INDEX=98;

-- Ex1 Q2
SELECT CR.CASE_NUMBER, CR.PRIMARY_TYPE, CE.COMMUNITY_AREA_NAME
FROM CHICAGO_CRIME_DATA CR LEFT OUTER JOIN CENSUS_DATA CE
ON CR.COMMUNITY_AREA_NUMBER = CE.COMMUNITY_AREA_NUMBER
WHERE CR.LOCATION_DESCRIPTION LIKE '%SCHOOL%';

-- Ex2 Q1
CREATE VIEW SCHOOLINFO (School_Name, Safety_Rating, Family_Rating, Environment_Rating, 
Instruction_Rating, Leaders_Rating, Teachers_Rating)
AS SELECT NAME_OF_SCHOOL, Safety_Icon, Family_Involvement_Icon, 
Environment_Icon, Instruction_Icon, Leaders_Icon, Teachers_Icon
FROM CHICAGO_PUBLIC_SCHOOLS;
SELECT SCHOOL_NAME, LEADERS_RATING FROM SCHOOLINFO;

-- Ex3 Q1
--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE (
    IN in_School_ID  INTEGER, IN in_Leader_Score INTEGER) 
LANGUAGE SQL 
MODIFIES SQL DATA

BEGIN
    UPDATE CHICAGO_PUBLIC_SCHOOLS
    SET Leaders_Score = in_Leader_Score
    WHERE School_ID = in_School_ID;
    IF in_Leader_Score>= 80 and in_Leader_Score <= 99 THEN 
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Very_Strong'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score>= 60 and in_Leader_Score <= 79  THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Strong'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score >=  40 and in_Leader_Score <= 59  THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Average'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score >=  20 and in_Leader_Score <= 39  THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Weak'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score >=  0 and in_Leader_Score <= 19  THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Very Weak'
        WHERE School_ID = in_School_ID;
    ELSE
        ROLLBACK WORK;
    END IF;
    
    COMMIT WORK;
END
@