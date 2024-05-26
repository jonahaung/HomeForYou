//
//  AppDelegateAdaptor.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 25/1/23.
//

import UIKit
import BackgroundTasks
import XUI
import FireAuthManager
import FirebaseAuth
import FirebaseMessaging

class AppDelegateAdaptor: NSObject, UIApplicationDelegate {
    
    lazy var appState = AppState()
    
    override init() {
        super.init()
        appState.configure()
    }
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { _, _ in })
            application.registerForRemoteNotifications()
            UNUserNotificationCenter.current().delegate = self
            return true
        }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let hexString = deviceToken.hexString
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        if Auth.auth().canHandleNotification(userInfo) {
            return .newData
        } else {
            Messaging.messaging().appDidReceiveMessage(userInfo)
            return .newData
        }
    }
}
extension AppDelegateAdaptor: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([.banner, .badge, .list])
        //        if let msgPayload = Msg.Payload.msgPayload(from: userInfo) {
        //            Audio.playMessageIncoming()
        //            if let currentConId {
        //                if currentConId == msgPayload.conId {
        //                    LocalNotifications.postMsg(payload: msgPayload)
        //                }
        //            } else {
        //                LocalNotifications.fireIncomingMsgNotification()
        //            }
        //            completionHandler(msgPayload.conId == self.currentConId ? [] : [.banner, .badge, .list])
        //        } else {
        //            completionHandler([.banner, .badge, .list])
        //        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        completionHandler()
        //        if let msgPayload = Msg.Payload.msgPayload(from: userInfo) {
        //            if let currentConId {
        //                if currentConId == msgPayload.conId {
        //                    LocalNotifications.postMsg(payload: msgPayload)
        //                }
        //            } else {
        //                LocalNotifications.fireIncomingMsgNotification()
        //            }
        //            ViewRouter.shared.routes.append(.chatView(conId: msgPayload.conId))
        //            completionHandler()
        //        } else {
        //            completionHandler()
        //        }
    }
    //    func unObserveMsgs() {
    //        firestoreListener?.remove()
    //        firestoreListener = nil
    //    }
    //    func observeMsgs() {
    //        unObserveMsgs()
    //        let reference = Firestore.firestore().collection("msgs")
    //        let query = reference.whereField("recipientId", isEqualTo: CurrentUser.id)
    //        firestoreListener = query.addSnapshotListener { snapshot, error in
    //            if let error {
    //                print(error)
    //                return
    //            }
    //            if let snapshot, !snapshot.isEmpty {
    //                let documents = snapshot.documents.compactMap{ $0.data() as NSDictionary }
    //                let msgs = documents.compactMap(MsgPayload.init)
    //                self.store.insert(payloads: msgs) {
    //                    snapshot.documents.forEach { each in
    //                        each.reference.delete()
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //    func fetchNewMsgs() {
    //        let reference = Firestore.firestore().collection("msgs")
    //        let query = reference.whereField("recipientId", isEqualTo: CurrentUser.id)
    //        query.getDocuments { snapshot, error in
    //            if let error {
    //                print(error)
    //                return
    //            }
    //            if let snapshot, !snapshot.isEmpty {
    //                let documents = snapshot.documents
    //                documents.forEach { document in
    //                    let dic = document.data() as NSDictionary
    //                    if let payload = MsgPayload(dic: dic) {
    //                        self.store.insert(payload: payload)
    //                    }
    //                    document.reference.delete()
    //                }
    //            }
    //        }
    //    }
}


// Background Fetch
extension AppDelegateAdaptor {
    private func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 0.5 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            Log(error)
        }
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
