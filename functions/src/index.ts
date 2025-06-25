import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";

admin.initializeApp();

export const kakaoSignIn = functions.https.onCall(async (data, _context) => {
  const kakaoAccessToken = data.token;

  try {
    // 1. 카카오 유저 정보 요청
    const kakaoRes = await axios.get("https://kapi.kakao.com/v2/user/me", {
      headers: {
        Authorization: `Bearer ${kakaoAccessToken}`,
      },
    });

    const kakaoUser = kakaoRes.data;
    const uid = `kakao:${kakaoUser.id}`; // 유니크 UID 생성

    // 2. Firebase 사용자 만들기 (이미 있으면 무시됨)
    await admin.auth().getUser(uid).catch(async (error) => {
      if (error.code === "auth/user-not-found") {
        await admin.auth().createUser({
          uid: uid,
        });
      } else {
        throw error;
      }
    });

    // 3. 커스텀 토큰 생성
    const customToken = await admin.auth().createCustomToken(uid);

    return {token: customToken};
  } catch (error: unknown) {
    const err = error as any;
    console.error("카카오 로그인 오류:", err.response?.data || err.message);
    throw new functions.https.HttpsError("internal", "카카오 로그인 실패");
  }
});
