import argparse
import os

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim


class SimpleNet(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim):
        super(SimpleNet, self).__init__()
        self.layer1 = nn.Linear(input_dim, hidden_dim)
        self.layer2 = nn.Linear(hidden_dim, output_dim)

    def forward(self, x):
        x = F.relu(self.layer1(x))
        return self.layer2(x)


def train(args):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    model = SimpleNet(
        input_dim=args.input_dim, hidden_dim=args.hidden_dim, output_dim=args.output_dim
    ).to(device)

    # Define loss function and optimizer
    # criterion = nn.MSELoss()
    # optimizer = optim.Adam(model.parameters(), lr=args.learning_rate)

    # Load data

    # Training loop
    for epoch in range(args.epochs):
        model.train()
        running_loss = 0.0

        # Your training loop here
        # Example:
        # for inputs, labels in train_loader:
        #     inputs, labels = inputs.to(device), labels.to(device)
        #     optimizer.zero_grad()
        #     outputs = model(inputs)
        #     loss = criterion(outputs, labels)
        #     loss.backward()
        #     optimizer.step()
        #     running_loss += loss.item()

        print(f"Epoch {epoch+1}, Loss: {running_loss}")

    # Save the model to S3
    save_model(model, args.model_dir)


def save_model(model, model_dir):
    path = os.path.join(model_dir, "model.pth")
    torch.save(model.state_dict(), path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    # Hyperparameters
    parser.add_argument("--epochs", type=int, default=10)
    parser.add_argument("--batch-size", type=int, default=32)
    parser.add_argument("--learning-rate", type=float, default=0.001)
    parser.add_argument("--input-dim", type=int, default=784)
    parser.add_argument("--hidden-dim", type=int, default=256)
    parser.add_argument("--output-dim", type=int, default=10)

    # Data, model, and output directories
    parser.add_argument(
        "--output-data-dir", type=str, default=os.environ["SM_OUTPUT_DATA_DIR"]
    )
    parser.add_argument("--model-dir", type=str, default=os.environ["SM_MODEL_DIR"])
    # parser.add_argument(
    #     "--data-dir", type=str, default=os.environ["SM_CHANNEL_TRAINING"]
    # )

    args = parser.parse_args()

    train(args)
