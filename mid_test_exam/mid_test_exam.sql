// 1. ���� ���̵� ���� �ݾ��� ������ �ۼ��Ͻÿ�

SELECT B.���̵�
         ,A."���� �ݾ�"      
FROM ADVERTISEMAIN B
LEFT JOIN (
            SELECT A.�����ڵ�
	         ,SUM(NVL(A.������Ŭ���籤���� * A.Ŭ���� * A.����� , 0 )) AS "���� �ݾ�"
            FROM KEYWORDBEFORE A
            GROUP BY A.�����ڵ�
            ORDER BY A.�����ڵ�
          	 ) A
ON B.�����ڵ� = A.�����ڵ�;

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

