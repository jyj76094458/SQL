// 2. ±è¾¾¼ºÀ» °¡Áø ±³À°»ýÀÇ Æò±Õ ³ªÀÌ

SELECT AVG(NVL(C.AGE,0)) AS "Æò±Õ ³ªÀÌ"
FROM(
    SELECT B.STNAME
             ,A.AGE
    FROM KOPO_GROUPBY_EX1_MAIN A
    LEFT JOIN KOPO_GROUPBY_EX1_USER B
    ON A.NAME = B.STCODE
    WHERE STNAME LIKE '±è%'
    ) C
GROUP BY C.AGE;

// 