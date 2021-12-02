//
// Created by dan on 30/11/2021.
//
void run_func(int opt, Pstring* p1, Pstring* p2){
    char oldChar, newChar;
    int startIdx, endIdx;
    Pstring *res, *res1, *res2;
    switch (opt) {
        case 50:
        case 60:
            printf("first pstring length: %d, second pstring length: %d\n", pstrlen(p1), pstrlen(p2));
            break;
        case 52:
            scanf("%c %c", &oldChar,  &newChar);
            printf("old char: %c, new char: %c, first string: %s, second string: %s\n",
                   oldChar, newChar, (replaceChar(p1,oldChar,newChar))->str, replaceChar(p2,oldChar,newChar)->str);
            break;
        case 53:
            scanf("%d %d", &startIdx, &endIdx);
            res = pstrijcpy(p1, p2, startIdx, endIdx);
            printf("length: %d, string: %s\n",res->len, res->str );
            printf("length: %d, string: %s\n",p2->len, p2->str );
            break;
        case 54:
            res1 = swapCase(p1);
            res2 = swapCase(p2);
            printf("length: %d, string: %s\n", res1->len, res1->str);
            printf("length: %d, string: %s\n", res2->len, res2->str);
            break;
        case 55:
            scanf("%d %d", &startIdx, &endIdx);
            printf("compare result: %d\n", pstrijcmp(p1, p2, startIdx, endIdx));
            break;
        default:
            printf("invalid option!\n");
    }
}

//void run_main(){
//    Pstring p1;
//    Pstring p2;
//    int len;
//    int opt;
//
//// initialize first pstring
//    scanf("%d", &len);
//    scanf("%s", p1.str);
//    p1.len = len;
//
//// initialize second pstring
//    scanf("%d", &len);
//    scanf("%s", p2.str);
//    p2.len = len;
//
//// select which function to run
//    scanf("%d", &opt);
//    getchar();
//    run_func(opt, &p1, &p2);
//}
