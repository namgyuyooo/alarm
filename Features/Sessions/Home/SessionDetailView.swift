import SwiftUI
import BedTimerKit

struct SessionDetailView: View {
    let session: BedSession
    let progress: Double
    let statusMessage: String
    let caption: String
    let formattedDuration: (Int) -> String
    let dateFormatter: DateFormatter
    
    private let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                Divider()
                summary
                Divider()
                timeline
                if let note = coachingMessage {
                    Divider()
                    coachingCard(note)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .presentationBackground(.thinMaterial)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dateFormatter.string(from: session.scheduledAlarm))
                .font(.title2.weight(.semibold))
            Text(statusMessage)
                .font(.headline)
                .foregroundStyle(.primary)
            Text(caption)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ProgressView(value: progress)
                .tint(session.isCompleted ? .green : .accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            Text(progressLabel)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
    
    private var summary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Summary")
                .font(.headline)
            HStack(spacing: 16) {
                metricTile(title: "Goal", value: formattedDuration(session.goalMinutes), symbol: "target")
                metricTile(title: "Elapsed", value: formattedDuration(session.elapsedMinutes), symbol: "hourglass")
                metricTile(title: "Result", value: resultLabel, symbol: session.metGoal ? "checkmark.circle.fill" : "xmark.circle")
            }
        }
    }
    
    private var timeline: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Timeline")
                .font(.headline)
            VStack(alignment: .leading, spacing: 8) {
                timelineRow(title: "Scheduled", date: session.scheduledAlarm)
                if let acknowledged = session.acknowledgedAt {
                    timelineRow(title: "Acknowledged", date: acknowledged)
                }
                if let outOfBed = session.outOfBedAt {
                    timelineRow(title: "Out of Bed", date: outOfBed)
                }
            }
        }
    }
    
    private func timelineRow(title: String, date: Date) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Text(date.formatted(date: .abbreviated, time: .shortened))
                .font(.subheadline)
            Text(relativeFormatter.localizedString(for: date, relativeTo: Date()))
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
    
    private func metricTile(title: String, value: String, symbol: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: symbol)
                .imageScale(.large)
                .foregroundStyle(.accent)
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private func coachingCard(_ message: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "figure.walk")
                .imageScale(.large)
                .foregroundStyle(Color.accentColor)
            Text(message)
                .font(.subheadline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.tertiarySystemBackground))
        )
    }
    
    private var progressLabel: String {
        let clamped = min(1, max(0, progress))
        let percent = Int((clamped * 100).rounded())
        if session.isCompleted {
            return "Finished • \(percent)% of goal time"
        }
        return "\(percent)% of goal time"
    }
    
    private var resultLabel: String {
        if session.isCompleted {
            return session.metGoal ? "Met goal" : formattedDuration(session.actualMinutes)
        }
        return session.isInProgress ? formattedDuration(session.remainingMinutes) : formattedDuration(session.goalMinutes)
    }
    
    private var coachingMessage: String? {
        if session.isCompleted {
            if session.metGoal {
                return "Great job getting out of bed within your target! Keep the streak going."
            } else {
                return "Review what slowed you down today and try shortening your linger time tomorrow."
            }
        }
        if session.isInProgress {
            return "Stay focused—leave the bed before the countdown hits zero to meet your goal."
        }
        return "Schedule an alarm and tap Start when you wake up to begin tracking."
    }
}

#Preview {
    let session = BedSession(
        scheduledAlarm: Date().addingTimeInterval(-3600),
        goalMinutes: 5,
        acknowledgedAt: Date().addingTimeInterval(-900),
        outOfBedAt: Date().addingTimeInterval(-300)
    )
    SessionDetailView(
        session: session,
        progress: session.goalProgress,
        statusMessage: "Completed in 5 min",
        caption: "Started at 7:15 AM · Finished at 7:20 AM",
        formattedDuration: { minutes in "\(minutes) min" },
        dateFormatter: {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }()
    )
}
