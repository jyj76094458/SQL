// 1. 광고 아이디별 과금 금액을 쿼리로 작성하시오

SELECT B.아이디
         ,A."과금 금액"      
FROM ADVERTISEMAIN B
LEFT JOIN (
            SELECT A.광고코드
	         ,SUM(NVL(A.설정한클릭당광고가격 * A.클릭수 * A.노출수 , 0 )) AS "과금 금액"
            FROM KEYWORDBEFORE A
            GROUP BY A.광고코드
            ORDER BY A.광고코드
          	 ) A
ON B.광고코드 = A.광고코드;

