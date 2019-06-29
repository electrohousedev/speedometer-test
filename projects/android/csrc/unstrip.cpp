#include <jni.h>

/// need only one function from file
extern "C" JNIEXPORT
void JNICALL Java_com_sandbox_Activity_nativeOnActivityCreated(
                                                                  JNIEnv *env,
                                                                  jobject thiz,
                                                                  jobject activity,
                                                                  jobject saved_instance_state);

/// stripped, becouse at archive whole .o content unused
volatile auto x = &Java_com_sandbox_Activity_nativeOnActivityCreated; 

