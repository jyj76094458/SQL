// 2. �达���� ���� �������� ��� ����

SELECT AVG(NVL(C.AGE,0)) AS "��� ����"
FROM(
    SELECT B.STNAME
             ,A.AGE
    FROM KOPO_GROUPBY_EX1_MAIN A
    LEFT JOIN KOPO_GROUPBY_EX1_USER B
    ON A.NAME = B.STCODE
    WHERE STNAME LIKE '��%'
    ) C
GROUP BY C.AGE;

// 