# cifar10_resnet_classifier.py

import torch
import torch.nn as nn
import torch.optim as optim
import torchvision
import torchvision.transforms as transforms
import matplotlib.pyplot as plt
import numpy as np

# データの前処理定義
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5)),
])

# CIFAR-10データセットのダウンロードとロード
trainset = torchvision.datasets.CIFAR10(root='./data', train=True, download=True, transform=transform)
trainloader = torch.utils.data.DataLoader(trainset, batch_size=4, shuffle=True)

testset = torchvision.datasets.CIFAR10(root='./data', train=False, download=True, transform=transform)
testloader = torch.utils.data.DataLoader(testset, batch_size=4, shuffle=False)

# ResNetの定義
import torchvision.models as models
net = models.resnet18(pretrained=False)
net.fc = nn.Linear(net.fc.in_features, 10)  # 出力層の変更（CIFAR-10は10クラスなので）

# 損失関数とオプティマイザの定義
criterion = nn.CrossEntropyLoss()
optimizer = optim.SGD(net.parameters(), lr=0.001, momentum=0.9)

# 学習の関数
def train_model(net, trainloader, criterion, optimizer, num_epochs=10):
    losses = []
    for epoch in range(num_epochs):
        running_loss = 0.0
        for i, data in enumerate(trainloader, 0):
            inputs, labels = data
            optimizer.zero_grad()

            outputs = net(inputs)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()

            running_loss += loss.item()
        
        losses.append(running_loss / len(trainloader))
        print(f"[Epoch {epoch+1}] loss: {running_loss / len(trainloader)}")
    
    print('Finished Training')
    return losses

# モデルの評価の関数
def evaluate_model(net, testloader):
    correct = 0
    total = 0
    with torch.no_grad():
        for data in testloader:
            images, labels = data
            outputs = net(images)
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()

    print(f'Accuracy of the network on the 10000 test images: {100 * correct / total}%')

# 学習曲線のプロットの関数
def plot_training_curve(losses):
    plt.figure()
    plt.plot(np.arange(len(losses)), losses, label='Training Loss')
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.title('Training Loss Curve')
    plt.legend()
    plt.show()

# 実際の学習
train_losses = train_model(net, trainloader, criterion, optimizer, num_epochs=10)
plot_training_curve(train_losses)

# モデルの評価
evaluate_model(net, testloader)
