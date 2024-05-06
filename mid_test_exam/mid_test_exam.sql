// ȸ���������̺� MEMBERINFO
// ����������̺� ADVERTISEMAIN
// Ű����������̺� KEYWORDBEFORE
// �������������̺� ADVERTISER

// 1. ���� ���̵� ���� �ݾ��� ������ �ۼ��Ͻÿ�

SELECT A.���̵�
      ,SUM(B.���ݱݾ�) AS ���̵𺰰��ݱݾ�
FROM ADVERTISEMAIN A
   ,(SELECT B.�����ڵ�
           ,SUM(B.������Ŭ���籤����*B.Ŭ����) AS ���ݱݾ�
     FROM KEYWORDBEFORE B
     WHERE 1=1
     AND NOT B.������Ŭ���籤���� IS NULL
     AND NOT B.Ŭ���� IS NULL
     GROUP BY B.�����ڵ�
     ORDER BY B.�����ڵ� ASC
     ) B
WHERE 1=1
AND A.�����ڵ� = B.�����ڵ�
GROUP BY A.���̵�;

// 2. 2023�� 5��12�� ���� ���̵� "����������"�� �����Ͻÿ� (���� �̹� �����ٸ�, "�Ⱓ����" ���� ������ ��)

SELECT A.���̵�
         ,CASE WHEN TO_DATE(A.�����) + TO_NUMBER(LPAD(A.�Ⱓ,2)) >= TO_DATE('2023/05/12', 'YYYY/MM/DD') THEN  TO_CHAR(TO_DATE(A.�����) + TO_NUMBER(LPAD(A.�Ⱓ,2)), 'YYYY/MM/DD')
	     WHEN TO_DATE(A.�����) + TO_NUMBER(LPAD(A.�Ⱓ,2)) < TO_DATE('2023/05/12', 'YYYY/MM/DD') THEN '�Ⱓ����'
      	     END AS ����������
FROM ADVERTISEMAIN A;

// 3. kaifox�� ���� ���� ����ϴ� ����� ���� �� ��ȭ��ȣ �� �̸����ּҸ� ��ȸ�ϱ� ���� ������ �ۼ��Ͻÿ�

SELECT B.���̵�
      ,C.�����
      ,C.��ȭ��ȣ
      ,C.�̸����ּ�
FROM ADVERTISER C
LEFT JOIN (SELECT A.���̵�
                 ,B.������
           FROM MEMBERINFO A
              ,(SELECT B.������
                      ,B.���̵�
                FROM ADVERTISEMAIN B) B
           WHERE 1=1
           AND A.���̵�=B.���̵�
           ) B
ON B.������ = C.������
WHERE 1=1
AND C.������ = 'taicode';

// 4. Ű���庰 Ŭ��Ƚ���� ǥ���ϴ� ������ �ۼ��Ͻÿ�

SELECT A.����Ű����
      ,NVL(SUM(A.Ŭ����),0) AS "Ű���庰 Ŭ��Ƚ��"
FROM KEYWORDBEFORE A
GROUP BY A.����Ű����;

// 5. "����Ʈ������" Ű���带 �˻� �� ���� ��ų ����Ʈ �����ּ� �� �������� ����ϴ� ������ �ۼ��Ͻÿ� (�� ������ Ŭ���� �������� ū ������ �Ǿտ� �;���)

SELECT A.����Ű����
      ,A.������Ŭ���籤����
      ,B.�����ּ�
      ,B.������
FROM ADVERTISEMAIN B
LEFT JOIN(
    SELECT A.�����ڵ�
          ,A.����Ű����
          ,A.������Ŭ���籤����
    FROM KEYWORDBEFORE A
    WHERE 1=1
    AND A.����Ű���� LIKE '����Ʈ������'
    ORDER BY A.������Ŭ���籤���� DESC
    ) A
ON B.�����ڵ� = A.�����ڵ�
WHERE 1=1
AND B.�����ڵ� = A.�����ڵ�;

// 6. ȸ�������� ������ ���� �������� ���� ���̵� ������ ��ȸ�ϴ� ������ �ۼ��Ͻÿ�

SELECT A.���̵�
FROM MEMBERINFO A
WHERE A.���̵� NOT IN(SELECT B.���̵�
                   FROM ADVERTISEMAIN B);

7. ����ں� ���� Ű���� ��� ������ ��ȸ�ϴ� ������ �ۼ��Ͻÿ� (��, 0�� ��� ��� �� ����, ���� ��հ�� �� �� ����)



// 8. ���� ���� ���� ��ϵ� ������ �������� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�

SELECT A.�����
      ,A.������
FROM ADVERTISEMAIN A
ORDER BY A.����� ASC;

// 9. 2023�� 5��12�� ���� Ȱ��ȭ�� Ű���庰 ������� ǥ���Ͻÿ� (��, ������� ���� ���� �����͸� ���� �����ֽÿ�)

SELECT B.����Ű����
      ,SUM(B.�����) AS Ȱ��ȭ��Ű���庰�����
FROM KEYWORDBEFORE B
    ,(SELECT A.���̵�
            ,A.�����ڵ�
            ,CASE WHEN TO_DATE(A.�����) + TO_NUMBER(LPAD(A.�Ⱓ,2)) >= TO_DATE('2023/05/12', 'YYYY/MM/DD') THEN  TO_CHAR(TO_DATE(A.�����) + TO_NUMBER(LPAD(A.�Ⱓ,2)), 'YYYY/MM/DD')
             WHEN TO_DATE(A.�����) + TO_NUMBER(LPAD(A.�Ⱓ,2)) < TO_DATE('2023/05/12', 'YYYY/MM/DD') THEN '�Ⱓ����'
      	     END AS ����������
      FROM ADVERTISEMAIN A
     ) A
WHERE 1=1
AND B.�����ڵ� = A.�����ڵ�
AND ���������� NOT IN('�Ⱓ����')
GROUP BY B.����Ű����
ORDER BY SUM(B.�����) DESC;

10. 'haiteam' ����ڰ� ������ ������ �����ּҺ� Ű���带 ��ȸ�ϱ����� ������ �ۼ��Ͻÿ�


