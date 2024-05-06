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

// 2. 2023년 5월12일 기준 아이디별 "광고종료일"을 산출하시오 (만약 이미 지났다면, "기간만료" 값을 넣으면 됨)

SELECT A.아이디
         ,CASE WHEN TO_DATE(A.등록일) + TO_NUMBER(LPAD(A.기간,2)) >= TO_DATE('2023/05/12', 'YYYY/MM/DD') THEN  TO_CHAR(TO_DATE(A.등록일) + TO_NUMBER(LPAD(A.기간,2)), 'YYYY/MM/DD')
	     WHEN TO_DATE(A.등록일) + TO_NUMBER(LPAD(A.기간,2)) < TO_DATE('2023/05/12', 'YYYY/MM/DD') THEN '기간만료'
      	     END AS 광고종료일
FROM ADVERTISEMAIN A;

// 3. kaifox가 본인 광고를 담당하는 담당자 정보 및 전화번호 및 이메일주소를 조회하기 위한 쿼리를 작성하시오

SELECT B.아이디
      ,C.담당자
      ,C.전화번호
      ,C.이메일주소
FROM ADVERTISER C
LEFT JOIN (SELECT A.아이디
                 ,B.광고주
           FROM MEMBERINFO A
              ,(SELECT B.광고주
                      ,B.아이디
                FROM ADVERTISEMAIN B) B
           WHERE 1=1
           AND A.아이디=B.아이디
           ) B
ON B.광고주 = C.광고주
WHERE 1=1
AND C.광고주 = 'taicode';

// 4. 키워드별 클릭횟수를 표시하는 쿼리를 작성하시오

SELECT A.광고키워드
      ,NVL(SUM(A.클릭수),0) AS "키워드별 클릭횟수"
FROM KEYWORDBEFORE A
GROUP BY A.광고키워드;

