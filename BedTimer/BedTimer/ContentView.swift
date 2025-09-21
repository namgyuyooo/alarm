//
//  ContentView.swift
//  BedTimer
//
//  Created by 유남규 on 9/21/25.
//

import SwiftUI
import SwiftData
import BedTimerKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BedSession.createdAt, order: .reverse) private var sessions: [BedSession]
    @State private var currentSession: BedSession?
    @State private var showingSettings = false
    @State private var timer: Timer?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // 헤더
                VStack(spacing: 8) {
                    Text("BedTimer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("침대에서 일어나는 시간을 추적하세요")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // 현재 세션 상태
                if let session = currentSession {
                    SessionStatusView(session: session)
                } else {
                    WelcomeView()
                }
                
                // 액션 버튼들
                VStack(spacing: 16) {
                    if currentSession?.isInProgress == true {
                        // 진행 중인 세션
                        Button(action: endSession) {
                            HStack {
                                Image(systemName: "bed.double.fill")
                                Text("침대에서 나가기")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    } else {
                        // 새 세션 시작
                        Button(action: startNewSession) {
                            HStack {
                                Image(systemName: "alarm.fill")
                                Text("알람 인지 - 세션 시작")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                
                // 최근 세션 목록
                if !sessions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("최근 세션")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView {
                            LazyVStack(spacing: 8) {
                                ForEach(sessions.prefix(5)) { session in
                                    SessionRowView(session: session)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onAppear {
            setupCurrentSession()
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func setupCurrentSession() {
        currentSession = sessions.first { $0.isInProgress }
    }
    
    private func startNewSession() {
        let newSession = BedSession(
            scheduledAlarm: Date(),
            goalMinutes: 5 // 기본 목표 시간 5분
        )
        
        do {
            modelContext.insert(newSession)
            newSession.start()
            try modelContext.save()
            currentSession = newSession
        } catch {
            print("세션 시작 실패: \(error)")
        }
    }
    
    private func endSession() {
        guard let session = currentSession else { return }
        
        session.end()
        
        do {
            try modelContext.save()
            currentSession = nil
        } catch {
            print("세션 종료 실패: \(error)")
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // UI 업데이트를 위한 타이머
        }
    }
}

struct SessionStatusView: View {
    let session: BedSession
    
    var body: some View {
        VStack(spacing: 16) {
            // 진행률 표시
            VStack(spacing: 8) {
                Text("목표까지 남은 시간")
                    .font(.headline)
                
                Text("\(session.remainingMinutes)분")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(session.remainingMinutes <= 0 ? .red : .primary)
            }
            
            // 진행률 바
            ProgressView(value: session.goalProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: session.metGoal ? .green : .blue))
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            Text("목표: \(session.goalMinutes)분 | 경과: \(session.elapsedMinutes)분")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bed.double.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("알람이 울리면")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("'알람 인지 - 세션 시작' 버튼을 눌러\n침대에서 나가는 시간을 추적해보세요")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct SessionRowView: View {
    let session: BedSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if session.isCompleted {
                    HStack {
                        Text("\(session.actualMinutes)분")
                        Text("•")
                        Text(session.metGoal ? "목표 달성" : "목표 미달성")
                            .foregroundColor(session.metGoal ? .green : .red)
                    }
                    .font(.caption)
                } else {
                    Text("진행 중")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            if session.metGoal {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("설정")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("알림 권한 설정, 목표 시간 조정 등의 기능이 여기에 추가될 예정입니다.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
