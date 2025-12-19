import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var workingFilter: VerbFilter
    var onSave: (VerbFilter) -> Void

    init(filter: VerbFilter, onSave: @escaping (VerbFilter) -> Void) {
        _workingFilter = State(initialValue: filter)
        self.onSave = onSave
    }

    var body: some View {
        Form {
            Section("Tenses") {
                ForEach(Tense.allCases) { tense in
                    Toggle(isOn: Binding(
                        get: { workingFilter.tenses.contains(tense) },
                        set: { isOn in
                            if isOn { workingFilter.tenses.insert(tense) } else { workingFilter.tenses.remove(tense) }
                        }
                    )) {
                        Text(tense.displayName)
                    }
                }
            }

            Section("Subjects") {
                Toggle("Disable vosotros (LatAm)", isOn: $workingFilter.disableVosotros)
                ForEach(SubjectPronoun.allCases) { subject in
                    Toggle(isOn: Binding(
                        get: { workingFilter.subjects.contains(subject) },
                        set: { isOn in
                            if isOn { workingFilter.subjects.insert(subject) } else { workingFilter.subjects.remove(subject) }
                        }
                    )) {
                        Text(subject.displayName)
                    }
                    .disabled(subject == .vosotros && workingFilter.disableVosotros)
                }
            }

            Section("Regularity") {
                ForEach(VerbRegularity.allCases) { regularity in
                    Toggle(isOn: Binding(
                        get: { workingFilter.regularities.contains(regularity) },
                        set: { isOn in
                            if isOn { workingFilter.regularities.insert(regularity) } else { workingFilter.regularities.remove(regularity) }
                        }
                    )) {
                        Text(regularity.displayName)
                    }
                }
            }

            Section("Verb endings") {
                ForEach(VerbEnding.allCases) { ending in
                    Toggle(isOn: Binding(
                        get: { workingFilter.endings.contains(ending) },
                        set: { isOn in
                            if isOn { workingFilter.endings.insert(ending) } else { workingFilter.endings.remove(ending) }
                        }
                    )) {
                        Text(ending.rawValue)
                    }
                }
            }
        }
        .navigationTitle("Filters")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Apply") {
                    onSave(workingFilter)
                    dismiss()
                }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FilterView(filter: VerbFilter()) { _ in }
        }
    }
}
