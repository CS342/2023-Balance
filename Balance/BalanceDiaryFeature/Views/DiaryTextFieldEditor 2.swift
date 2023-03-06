import SwiftUI

//all code that I found online but uses TextField
let dateFormatter = DateFormatter()

struct ContentView: View {
    @State var items: [NoteItem] = {
        guard let data = UserDefaults.standard.data(forKey: "notes") else {
            return []
        }
        if let json = try? JSONDecoder().decode([NoteItem].self, from: data) {
            return json
        }
        return []
    }()
    
    @State var taskText: String = ""
    
    @State var showAlert = false
    
    @State var itemToDelete: NoteItem?
    
    var alert: Alert {
        Alert(
            title: Text("Hey!"),
            message: Text("Are you sure you want to delete this item?"),
            primaryButton: .destructive(Text("Delete"), action: deleteNote),
            secondaryButton: .cancel()
        )
    }
    
    var inputView: some View {
        HStack {
            TextField("Write a note ...", text: $taskText)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .clipped()
            Button(action: didTapAddTask, label: { Text("Add") }).padding(8)
        }
    }
    
    var body: some View {
        VStack {
            inputView
            Divider()
            List(items) { item in
                VStack(alignment: .leading) {
                    Text(item.dateText).font(.headline)
                    Text(item.text).lineLimit(nil).multilineTextAlignment(.leading)
                }
                .onLongPressGesture {
                    self.itemToDelete = item
                    self.showAlert = true
                }
            }
            .alert(isPresented: $showAlert, content: {
                alert
            })
        }
    }
    
    func didTapAddTask() {
        let id = items.reduce(0) { max($0, $1.id) } + 1
        items.insert(NoteItem(id: id, text: taskText), at: 0)
        taskText = ""
        save()
    }
    
    func deleteNote() {
        guard let itemToDelete = itemToDelete else {
            return
        }
        items = items.filter { $0 != itemToDelete }
        save()
    }
    
    func save() {
        guard let data = try? JSONEncoder().encode(items) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "notes")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
