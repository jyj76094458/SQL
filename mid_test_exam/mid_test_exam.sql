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

