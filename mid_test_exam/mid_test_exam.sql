// 회원정보테이블 MEMBERINFO
// 광고메인테이블 ADVERTISEMAIN
// 키워드관리테이블 KEYWORDBEFORE
// 광고주정보테이블 ADVERTISER

// 1. 광고 아이디별 과금 금액을 쿼리로 작성하시오

SELECT A.아이디
      ,SUM(B.과금금액) AS 아이디별과금금액
FROM ADVERTISEMAIN A
   ,(SELECT B.광고코드
           ,SUM(B.설정한클릭당광고가격*B.클릭수) AS 과금금액
     FROM KEYWORDBEFORE B
     WHERE 1=1
     AND NOT B.설정한클릭당광고가격 IS NULL
     AND NOT B.클릭수 IS NULL
     GROUP BY B.광고코드
     ORDER BY B.광고코드 ASC
     ) B
WHERE 1=1
AND A.광고코드 = B.광고코드
GROUP BY A.아이디;

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

// 5. "스마트금융과" 키워드를 검색 시 노출 시킬 사이트 광고주소 및 광고설명을 출력하는 쿼리를 작성하시오 (단 설정한 클릭당 광고가격이 큰 순서가 맨앞에 와야함)

SELECT A.광고키워드
      ,A.설정한클릭당광고가격
      ,B.광고주소
      ,B.광고설명
FROM ADVERTISEMAIN B
LEFT JOIN(
    SELECT A.광고코드
          ,A.광고키워드
          ,A.설정한클릭당광고가격
    FROM KEYWORDBEFORE A
    WHERE 1=1
    AND A.광고키워드 LIKE '스마트금융과'
    ORDER BY A.설정한클릭당광고가격 DESC
    ) A
ON B.광고코드 = A.광고코드
WHERE 1=1
AND B.광고코드 = A.광고코드;

// 6. 회원가입은 했으나 광고를 실행하지 않은 아이디 정보를 조회하는 쿼리를 작성하시오

SELECT A.아이디
FROM MEMBERINFO A
WHERE A.아이디 NOT IN(SELECT B.아이디
                   FROM ADVERTISEMAIN B);

// 7. 사용자별 광고 키워드 평균 가격을 조회하는 쿼리를 작성하시오 (단, 0은 평균 계산 시 포함, 빈값은 평균계산 시 미 포함)

SELECT A.아이디
      ,SUM(B.설정한클릭당광고가격) 
      ,SUM(B.클릭수)
      ,AVG(B.설정한클릭당광고가격)
      ,AVG(B.클릭수)
      ,AVG(B.설정한클릭당광고가격*B.클릭수)
      ,AVG(B.설정한클릭당광고가격) * AVG(B.클릭수)
FROM ADVERTISEMAIN A
LEFT JOIN(SELECT B.광고코드
                ,B.설정한클릭당광고가격
                ,B.클릭수
          FROM KEYWORDBEFORE B) B
ON A.광고코드 = B.광고코드
GROUP BY A.아이디;

-- 답안 --

SELECT A.아이디
      ,AVG(B.설정한클릭당광고가격 * B.클릭수) AS 사용자별광고키워드평균가격
FROM ADVERTISEMAIN A
LEFT JOIN(SELECT B.광고코드
                ,B.설정한클릭당광고가격
                ,B.클릭수
          FROM KEYWORDBEFORE B) B
ON A.광고코드 = B.광고코드
GROUP BY A.아이디;

// 8. 광고가 가장 먼저 등록된 시점이 언제인지 조회하는 쿼리를 작성하시오

SELECT A.등록일
      ,A.광고설명
FROM ADVERTISEMAIN A
ORDER BY A.등록일 ASC;

// 9. 2023년 5월12일 기준 활성화된 키워드별 노출수를 표시하시오 (단, 노출수가 가장 많은 데이터를 먼저 보여주시오)

SELECT B.광고키워드
      ,SUM(B.노출수) AS 활성화된키워드별노출수
FROM KEYWORDBEFORE B
    ,(SELECT A.아이디
            ,A.광고코드
            ,CASE WHEN TO_DATE(A.등록일) + TO_NUMBER(LPAD(A.기간,2)) >= TO_DATE('2023/05/12', 'YYYY/MM/DD') THEN  TO_CHAR(TO_DATE(A.등록일) + TO_NUMBER(LPAD(A.기간,2)), 'YYYY/MM/DD')
             WHEN TO_DATE(A.등록일) + TO_NUMBER(LPAD(A.기간,2)) < TO_DATE('2023/05/12', 'YYYY/MM/DD') THEN '기간만료'
      	     END AS 광고종료일
      FROM ADVERTISEMAIN A
     ) A
WHERE 1=1
AND B.광고코드 = A.광고코드
AND 광고종료일 NOT IN('기간만료')
GROUP BY B.광고키워드
ORDER BY SUM(B.노출수) DESC;

// 10. 'haiteam' 사용자가 본인이 광고한 광고주소별 키워드를 조회하기위한 쿼리를 작성하시오

SELECT A.아이디
      ,A.광고주소
      ,A.광고설명
      ,B.광고키워드
FROM ADVERTISEMAIN A
LEFT JOIN(SELECT B.광고코드
                ,B.광고키워드
          FROM KEYWORDBEFORE B) B
ON A.광고코드 = B.광고코드
WHERE 1=1
AND A.아이디 LIKE 'haiteam'
AND A.광고설명 LIKE '%'||B.광고키워드||'%';

-- 정답 -- 

SELECT A.아이디
      ,A.광고주소
      ,B.광고키워드
FROM ADVERTISEMAIN A
LEFT JOIN(SELECT B.광고코드
                ,B.광고키워드
          FROM KEYWORDBEFORE B) B
ON A.광고코드 = B.광고코드
WHERE 1=1
AND A.아이디 LIKE 'haiteam'
AND A.광고설명 LIKE '%'||B.광고키워드||'%';