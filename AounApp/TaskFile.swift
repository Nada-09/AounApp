import Foundation
import SwiftData

@Model
class TaskFile {
    @Attribute var title: String
    @Attribute var tasks: [String]
    @Attribute var iconName: String // إضافة الخاصية iconName

    init(title: String, tasks: [String] = [], iconName: String = "folder.fill") {
        self.title = title
        self.tasks = tasks
        self.iconName = iconName
    }
}
